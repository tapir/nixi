#!/usr/bin/env python3
"""Keep a fixed monitor layout, matched by EDID identity instead of connector name.

Mutter persists layouts in ~/.config/monitors.xml keyed on connector + vendor +
product + serial. DRM takes connector names from the lowest free integer, so a
dock that re-enumerates renames them (DP-7 -> DP-10) and the stored layout stops
matching. This watches mutter for topology changes and re-applies a layout keyed
only on EDID identity.

Usage: dock-display-layout.py <layout.json> [--once] [--dry-run] [--verify] [--force]
"""

import json
import os
import sys
import time
import xml.etree.ElementTree as ET

import gi

gi.require_version("Gio", "2.0")
from gi.repository import Gio, GLib  # noqa: E402

BUS_NAME = "org.gnome.Mutter.DisplayConfig"
OBJ_PATH = "/org/gnome/Mutter/DisplayConfig"
IFACE = "org.gnome.Mutter.DisplayConfig"
METHOD_VERIFY = 0          # check the config without switching to it
METHOD_PERSISTENT = 2      # switch and store it in monitors.xml
SETTLE_MS = 1200           # topology keeps moving for a moment after a hotplug
MIN_APPLY_INTERVAL = 3.0   # guards against re-applying in a signal loop
POLL_SECONDS = 30          # backstop for signals missed while mutter restarts


def log(msg):
    print(msg, flush=True)


def call(bus, method, args=None, timeout_ms=-1):
    return bus.call_sync(BUS_NAME, OBJ_PATH, IFACE, method, args, None,
                         Gio.DBusCallFlags.NONE, timeout_ms, None).unpack()


def remembered_modes():
    """Last mode per EDID serial, as the user left it in monitors.xml."""
    modes = {}
    try:
        root = ET.parse(os.path.expanduser("~/.config/monitors.xml")).getroot()
    except (OSError, ET.ParseError):
        return modes
    for conf in root.findall("configuration"):
        for lm in conf.findall("logicalmonitor"):
            spec, mode = lm.find("monitor/monitorspec"), lm.find("monitor/mode")
            if spec is None or mode is None:
                continue
            serial = spec.findtext("serial")
            try:
                modes.setdefault(serial, "%sx%s@%s" % (mode.findtext("width"),
                                                      mode.findtext("height"),
                                                      mode.findtext("rate")))
            except TypeError:
                continue
    return modes


def mode_size(mode):
    try:
        return int(mode.split("x")[0]), int(mode.split("x")[1].split("@")[0])
    except (ValueError, IndexError):
        return 1920, 1080


def read_present(monitors):
    present = {}
    for entity, modes, props in monitors:
        connector, vendor, product, serial = entity
        present[serial or connector] = dict(connector=connector, modes=[m[0] for m in modes],
                                            builtin=bool(props.get("is-builtin")))
    return present


def read_current(logical):
    current = {}
    for x, y, scale, transform, primary, mons, _props in logical:
        for _connector, _vendor, _product, serial in mons:
            current[serial] = dict(x=x, y=y, scale=scale, transform=transform,
                                   primary=bool(primary))
    return current


def logical_width(placement):
    width, height = mode_size(placement["mode"])
    if placement["transform"] in (1, 3):
        width, height = height, width
    return int(width / (placement["scale"] or 1.0))


def resolve(spec, present, current, remembered):
    """Turn the spec into placements for the monitors that are plugged in and active."""
    placements = {}
    for entry in spec:
        info = present.get(entry["serial"])
        if info is None or not entry.get("enabled", True):
            continue
        now = current.get(entry["serial"], {})
        wanted = entry.get("mode") or remembered.get(entry["serial"])
        placements[entry["serial"]] = dict(
            connector=info["connector"],
            mode=wanted if wanted in info["modes"] else info["modes"][0],
            x=int(entry["x"]), y=int(entry["y"]),
            scale=float(entry.get("scale") or now.get("scale") or 1.0),
            transform=int(entry.get("transform", now.get("transform", 0))),
            primary=bool(entry.get("primary", False)),
            fixed=True)

    # a monitor with no spec entry keeps working, placed to the right of the rest;
    # one the user switched off stays off
    right = max((p["x"] + logical_width(p) for p in placements.values()), default=0)
    for serial, info in present.items():
        if serial in placements or serial not in current:
            continue
        wanted = remembered.get(serial)
        placement = dict(connector=info["connector"],
                         mode=wanted if wanted in info["modes"] else info["modes"][0],
                         x=right, y=0, scale=float(current[serial]["scale"]),
                         transform=int(current[serial]["transform"]), primary=False,
                         fixed=False)
        placements[serial] = placement
        right += logical_width(placement)

    if not placements:
        return {}
    if not any(p["primary"] for p in placements.values()):
        primary = next((s for s in placements if present[s]["builtin"]), next(iter(placements)))
        placements[primary]["primary"] = True

    # whatever subset is attached, the layout has to start at the origin; the
    # relative arrangement is what the spec describes
    left = min(p["x"] for p in placements.values())
    top = min(p["y"] for p in placements.values())
    for placement in placements.values():
        placement["x"] -= left
        placement["y"] -= top
    return placements


def connected(monitors):
    return frozenset(entity[3] or entity[0] for entity, _modes, _props in monitors)


def already_matches(placements, current):
    if set(placements) != set(current):
        return False
    for serial, want in placements.items():
        now = current[serial]
        if (want["x"], want["y"], round(want["scale"], 6), want["transform"], want["primary"]) != \
           (now["x"], now["y"], round(now["scale"], 6), now["transform"], now["primary"]):
            return False
    return True


def apply_layout(bus, serial, placements, method):
    logical = []
    for placement in placements.values():
        logical.append("(%d, %d, %r, %d, %s, [(%s, %s, @a{sv} {})])" % (
            placement["x"], placement["y"], placement["scale"], placement["transform"],
            "true" if placement["primary"] else "false",
            json.dumps(placement["connector"]), json.dumps(placement["mode"])))
    text = "(%d, %d, [%s], @a{sv} {})" % (serial, method, ", ".join(logical))
    args = GLib.Variant.parse(GLib.VariantType.new("(uua(iiduba(ssa{sv}))a{sv})"),
                              text, None, None)
    bus.call_sync(BUS_NAME, OBJ_PATH, IFACE, "ApplyMonitorsConfig", args, None,
                  Gio.DBusCallFlags.NONE, 5000, None)


def main():
    positional = [a for a in sys.argv[1:] if not a.startswith("--")]
    flags = {a for a in sys.argv[1:] if a.startswith("--")}
    if not positional:
        sys.exit(__doc__)
    spec = json.load(open(positional[0]))["monitors"]
    method = METHOD_VERIFY if "--verify" in flags else METHOD_PERSISTENT
    dry_run = "--dry-run" in flags

    bus = Gio.bus_get_sync(Gio.BusType.SESSION, None)
    state = {"last_apply": 0.0, "waiting": False, "connected": None}

    def reconcile():
        try:
            serial, monitors, logical, _props = call(bus, "GetCurrentState")
        except GLib.Error as err:
            if not state["waiting"]:
                log("waiting for %s: %s" % (BUS_NAME, err.message))
                state["waiting"] = True
            return False
        state["waiting"] = False
        state["connected"] = connected(monitors)

        placements = resolve(spec, read_present(monitors), read_current(logical),
                             remembered_modes())
        if not placements:
            log("no known monitor attached")
            return False

        for serial_id, p in placements.items():
            log("%-11s -> %-7s %-18s %3d,%-5d scale %.3f rot %d%s%s"
                % (serial_id, p["connector"], p["mode"], p["x"], p["y"], p["scale"],
                   p["transform"], " primary" if p["primary"] else "",
                   "" if p["fixed"] else " (auto-placed)"))

        if already_matches(placements, read_current(logical)) and "--force" not in flags:
            log("layout already correct")
            return False
        if dry_run:
            log("dry run, not applying")
            return False

        log("verifying" if method == METHOD_VERIFY else "applying layout")
        try:
            apply_layout(bus, serial, placements, method)
        except GLib.Error as err:
            log("apply failed: %s" % err.message)
        state["last_apply"] = time.monotonic()
        return False

    def on_changed(*_args):
        if time.monotonic() - state["last_apply"] < MIN_APPLY_INTERVAL:
            return
        GLib.timeout_add(SETTLE_MS, reconcile)

    bus.signal_subscribe(BUS_NAME, IFACE, "MonitorsChanged", OBJ_PATH, None,
                         Gio.DBusSignalFlags.NONE, on_changed)
    reconcile()
    if "--once" in flags:
        return 0

    def schedule_poll():
        GLib.timeout_add_seconds(2 if state["waiting"] else POLL_SECONDS, poll)

    def poll():
        # only a change in what is plugged in may override the user's current
        # arrangement; a manual move leaves connectivity untouched and stands
        try:
            _serial, monitors, _logical, _props = call(bus, "GetCurrentState")
        except GLib.Error:
            reconcile()
        else:
            if connected(monitors) != state["connected"]:
                log("missed a topology change, reconciling")
                reconcile()
        schedule_poll()
        return False

    schedule_poll()
    GLib.MainLoop().run()
    return 0


if __name__ == "__main__":
    sys.exit(main())
