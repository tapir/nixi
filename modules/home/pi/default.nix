# pi coding agent — global configuration seeds
#
# IMPORTANT: pi mutates its own config files at runtime (`pi install`,
# /settings, model switching, curator provider changes...), so these files
# are NOT managed as read-only nix symlinks. Instead this module SEEDS them
# on activation when they don't exist yet (fresh machine / fresh home).
#
# The payloads live as plain files next to this module (settings.json,
# web-search.json, auth.json, AGENTS.md) so they can be edited directly
# instead of as inline nix strings. builtins.fromJSON validates them at
# eval time: a typo fails `nixswitch`, never activation.
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
  authJson = pkgs.writeText "pi-auth.json" (
    # Security Note: This puts the placeholder in the world-readable /nix/store.
    # Use agenix/sops-nix for real keys, or add them manually after deployment.
    builtins.toJSON (builtins.fromJSON (builtins.readFile ./auth.json))
  );
in
{
  # Seed pi config files only when absent; live files belong to pi/the user.
  home.activation.piSeedConfigs = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    # Keep a legacy symlink for any hardcoded extensions expecting ~/.pi
    run mkdir $VERBOSE_ARG -p "$HOME/.config/pi"
    run ln $VERBOSE_ARG -sfn "$HOME/.config/pi" "$HOME/.pi"

    if [ ! -e "$HOME/.config/pi/settings.json" ]; then
      run cp $VERBOSE_ARG ${settingsJson} "$HOME/.config/pi/settings.json"
      # Make it writable by the user so Pi can mutate it
      run chmod $VERBOSE_ARG 644 "$HOME/.config/pi/settings.json"
    fi

    if [ ! -e "$HOME/.config/pi/web-search.json" ]; then
      run cp $VERBOSE_ARG ${webSearchJson} "$HOME/.config/pi/web-search.json"
      run chmod $VERBOSE_ARG 600 "$HOME/.config/pi/web-search.json"
    fi

    if [ ! -e "$HOME/.config/pi/AGENTS.md" ]; then
      run cp $VERBOSE_ARG ${./AGENTS.md} "$HOME/.config/pi/AGENTS.md"
      run chmod $VERBOSE_ARG 644 "$HOME/.config/pi/AGENTS.md"
    fi

    if [ ! -e "$HOME/.config/pi/auth.json" ]; then
      run cp $VERBOSE_ARG ${authJson} "$HOME/.config/pi/auth.json"
      run chmod $VERBOSE_ARG 600 "$HOME/.config/pi/auth.json"
    fi

    if [ ! -e "$HOME/.config/pi/trust.json" ]; then
      run cp $VERBOSE_ARG ${trustJson} "$HOME/.config/pi/trust.json"
      run chmod $VERBOSE_ARG 600 "$HOME/.config/pi/trust.json"
    fi

    if [ ! -e "$HOME/.config/pi/pi-codegraph-enhanced.json" ]; then
      run cp $VERBOSE_ARG ${codegraphJson} "$HOME/.config/pi/pi-codegraph-enhanced.json"
      run chmod $VERBOSE_ARG 600 "$HOME/.config/pi/pi-codegraph-enhanced.json"
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
    PI_CODING_AGENT_DIR = "$HOME/.config/pi";
  };
}
