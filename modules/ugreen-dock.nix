{ pkgs, ... }:

let
  # Layout is keyed on EDID serial, never on connector name: DRM names MST
  # connectors from the lowest free integer, so the dock renumbering its outputs
  # (DP-7 -> DP-10) leaves GNOME's connector-keyed layout matching nothing.
  displayLayout = pkgs.writeText "ugreen-dock-display-layout.json" (builtins.toJSON {
    monitors = [
      { serial = "CNK14921K5"; x = 0; y = 0; transform = 1; } # left, portrait
      { serial = "CNK1151RTS"; x = 1080; y = 0; } # right
      { serial = "0x0000ffa1"; x = 1080; y = 1080; primary = true; } # built-in panel
      # CNK14910HQ is placed automatically until it gets an entry here
    ];
  });

  layoutPython = pkgs.python3.withPackages (ps: [ ps.pygobject3 ]);
in
{
  # Re-apply the layout whenever the dock enumerates under different connector names
  systemd.user.services.dock-display-layout = {
    description = "Keep the monitor layout fixed by EDID identity";
    wantedBy = [ "default.target" ];
    partOf = [ "graphical-session.target" ];
    environment = {
      DBUS_SESSION_BUS_ADDRESS = "unix:path=/run/user/%U/bus";
      XDG_RUNTIME_DIR = "/run/user/%U";
    };
    serviceConfig = {
      ExecStart = "${layoutPython}/bin/python3 ${./ugreen-dock-display-layout.py} ${displayLayout}";
      Restart = "always";
      RestartSec = 5;
    };
  };

  # Rename the dongle to usbeth0 based on MAC
  systemd.network.links."10-usbeth0" = {
    matchConfig.MACAddress = "6c:1f:f7:75:07:ae";
    linkConfig.Name = "usbeth0";
  };

  # Apply ethtool tuning when the device appears
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="net", ATTR{address}=="6c:1f:f7:75:07:ae", RUN+="${pkgs.ethtool}/bin/ethtool --set-eee usbeth0 eee off"
  '';

  # cdc_ether module is buggy
  boot = {
    blacklistedKernelModules = [ "cdc_ether" ];
    kernelModules = [ "r8152" ];
  };

  # Need this to set the realtek chip config
  environment.systemPackages = [ pkgs.ethtool ];
}
