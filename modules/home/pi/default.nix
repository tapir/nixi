# pi coding agent — global configuration seeds
#
# IMPORTANT: pi mutates its own config files at runtime (`pi install`,
# /settings, model switching, curator provider changes...), so these files
# are NOT managed as read-only nix symlinks. Instead this module SEEDS them
# on activation when they don't exist yet (fresh machine / fresh home).
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
# authenticates through pi itself.
#
# To reset any file to the nix-managed version: delete the live file and
# re-run home-manager switch, e.g.:
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

    if [ ! -e "$HOME/.config/pi/settings.json" ]; then
      run cp $VERBOSE_ARG ${settingsJson} "$HOME/.config/pi/settings.json"
      # Make it writable by the user so Pi can mutate it
      run chmod $VERBOSE_ARG 644 "$HOME/.config/pi/settings.json"
    fi

    if [ ! -e "$HOME/.config/pi/web-search.json" ]; then
      run cp $VERBOSE_ARG ${webSearchJson} "$HOME/.config/pi/web-search.json"
      run chmod $VERBOSE_ARG 600 "$HOME/.config/pi/web-search.json"
    fi

    if [ ! -e "$HOME/.config/pi/trust.json" ]; then
      run cp $VERBOSE_ARG ${trustJson} "$HOME/.config/pi/trust.json"
      run chmod $VERBOSE_ARG 600 "$HOME/.config/pi/trust.json"
    fi

    if [ ! -e "$HOME/.config/pi/pi-codegraph-enhanced.json" ]; then
      run cp $VERBOSE_ARG ${codegraphJson} "$HOME/.config/pi/pi-codegraph-enhanced.json"
      run chmod $VERBOSE_ARG 600 "$HOME/.config/pi/pi-codegraph-enhanced.json"
    fi

    if [ ! -e "$HOME/.config/pi/caveman.json" ]; then
      run cp $VERBOSE_ARG ${cavemanJson} "$HOME/.config/pi/caveman.json"
      run chmod $VERBOSE_ARG 600 "$HOME/.config/pi/caveman.json"
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
