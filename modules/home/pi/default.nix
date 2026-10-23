# pi coding agent — global configuration seeds
#
# IMPORTANT: pi mutates its own config files at runtime (`pi install`,
# /settings, model switching, trust decisions...), so read-only store
# symlinks would fail those writes — an unwritable trust.json even crashes
# pi. Instead the files live as regular writable files and activation
# re-copies them from the store whenever the payload in this module changed
# (a stamp symlink under ~/.config/pi/.nix-seed records the last seeded
# store path). Edit the JSON files next to this module to change config;
# pi's runtime edits to the live files survive until the next payload change.
#
# The payloads live as plain files next to this module (settings.json,
# web-search.json, ...) so they can be edited directly instead of as inline
# nix strings. builtins.fromJSON validates them at eval time: a typo fails
# `nixswitch`, never activation.
#
# AGENTS.md is the exception: pi never rewrites it, so it is a read-only
# store symlink and this module is its only source of truth.
#
# auth.json is deliberately not seeded: it holds API keys. A fresh machine
# authenticates through pi itself. web-search.json holds machine-local API
# keys too (the repo payload carries placeholders), so it is seed-only and
# never force-updated.
#
# To force a file back to the nix version: delete the live file (or its
# stamp) and re-run home-manager switch, e.g.:
#   rm ~/.config/pi/settings.json && nixswitch

{ config, pkgs, ... }:

let
  # Validated at eval time, re-serialized into the store for seeding.
  settingsJson = pkgs.writeText "pi-settings.json" (
    builtins.toJSON (builtins.fromJSON (builtins.readFile ./settings.json))
  );
  webSearchJson = pkgs.writeText "pi-web-search.json" (
    builtins.toJSON (builtins.fromJSON (builtins.readFile ./web-search.json))
  );
  trustJson = pkgs.writeText "pi-trust.json" (
    builtins.toJSON (builtins.fromJSON (builtins.readFile ./trust.json))
  );
  codegraphJson = pkgs.writeText "pi-codegraph-enhanced.json" (
    builtins.toJSON (builtins.fromJSON (builtins.readFile ./pi-codegraph-enhanced.json))
  );
  cavemanJson = pkgs.writeText "caveman.json" (
    builtins.toJSON (builtins.fromJSON (builtins.readFile ./caveman.json))
  );
in
{
  home.file.".config/pi/AGENTS.md".source = ./AGENTS.md;

  # One-shot: drop the file the old seeding left behind, home-manager refuses
  # to clobber a real file with a symlink.
  home.activation.piUnseedAgentsMd = config.lib.dag.entryBefore [ "writeBoundary" ] ''
    if [ -e "$HOME/.config/pi/AGENTS.md" ] && [ ! -L "$HOME/.config/pi/AGENTS.md" ]; then
      run rm $VERBOSE_ARG -f "$HOME/.config/pi/AGENTS.md"
    fi
  '';

  # Seed pi config files only when absent; live files belong to pi/the user.
  home.activation.piSeedConfigs = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    # Keep a legacy symlink for any hardcoded extensions expecting ~/.pi
    run mkdir $VERBOSE_ARG -p "$HOME/.config/pi"
    run ln $VERBOSE_ARG -sfn "$HOME/.config/pi" "$HOME/.pi"

    # pi-subagents scans both ~/.agents and $PI_CODING_AGENT_DIR/agents; one
    # target keeps the profiles from modules/home/agents the only copy.
    run ln $VERBOSE_ARG -sfn "$HOME/.agents" "$HOME/.config/pi/agents"

    # Re-copy a config from the store when it is missing or the payload
    # changed since the last seed; the stamp symlink records the store path.
    piSeedConfig() {
      local src="$1" target="$2" mode="$3"
      local stamp="$HOME/.config/pi/.nix-seed/$(basename "$target")"
      if [ -e "$target" ] && [ "$(readlink "$stamp" 2>/dev/null)" = "$src" ]; then
        return 0
      fi
      run mkdir $VERBOSE_ARG -p "$(dirname "$stamp")"
      run cp $VERBOSE_ARG -f "$src" "$target"
      run chmod $VERBOSE_ARG "$mode" "$target"
      run ln $VERBOSE_ARG -sfn "$src" "$stamp"
    }

    piSeedConfig ${settingsJson} "$HOME/.config/pi/settings.json" 644
    piSeedConfig ${trustJson} "$HOME/.config/pi/trust.json" 600
    piSeedConfig ${codegraphJson} "$HOME/.config/pi/pi-codegraph-enhanced.json" 600
    piSeedConfig ${cavemanJson} "$HOME/.config/pi/caveman.json" 600

    # Seed-only: the live file carries real API keys, the repo payload only
    # placeholders — clobbering would break web search.
    if [ ! -e "$HOME/.config/pi/web-search.json" ]; then
      run cp $VERBOSE_ARG ${webSearchJson} "$HOME/.config/pi/web-search.json"
      run chmod $VERBOSE_ARG 600 "$HOME/.config/pi/web-search.json"
    fi
  '';

  programs.bash = {
    enable = true;
    initExtra = ''
      export PI_CODING_AGENT_DIR="$HOME/.config/pi"
    '';
  };

  # Also setting sessionVariables is highly recommended so it applies
  # globally to non-bash sessions (like Wayland/X11 environments)
  home.sessionVariables = {
    PONYTAIL_DEFAULT_MODE = "ultra";
    PI_CODING_AGENT_DIR = "$HOME/.config/pi";
  };
}
