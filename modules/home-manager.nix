{
  config,
  pkgs,
  lib,
  ...
}:
{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = {
    nixosConfig = config;
  };

  home-manager.users.cosku =
    { pkgs, lib, ... }:
    {
      home.activation.firefoxGnomeTheme = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        theme_version="${pkgs.firefox-gnome-theme.version or "unknown"}"
        stamp_dir="$HOME/.cache/firefox-gnome-theme"
        stamp="$stamp_dir/installed-$theme_version"

        if [ ! -f "$stamp" ]; then
          ${pkgs.firefox-gnome-theme}/bin/install.sh
          mkdir -p "$stamp_dir"
          rm -f "$stamp_dir/installed-"*
          touch "$stamp"
        fi
      '';
    };
}
