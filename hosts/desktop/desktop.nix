{ pkgs, ... }:

{
    imports = [
        ./hardware-configuration.nix
        ../../modules/boot.nix
        ../../modules/base.nix
        ../../modules/packages.nix
        ../../modules/nvidia.nix
    ];

    networking.hostName = "nixcosh-desktop";

    environment.systemPackages = with pkgs; [
        steam
    ];

    services.flatpak = {
        enable = true;
        packages = [
            "com.discordapp.Discord"
            "com.github.tchx84.Flatseal"
            "com.mattjakeman.ExtensionManager"
            "com.orcaslicer.OrcaSlicer"
            "com.ranfdev.DistroShelf"
            "io.dbeaver.DBeaverCommunity"
            "io.github.celluloid_player.Celluloid"
            "net.nokyan.Resources"
            "org.gimp.GIMP"
            "org.gnome.Calculator"
            "org.gnome.Firmware"
            "org.gnome.Logs"
            "org.gnome.Loupe"
            "org.gnome.Papers"
            "org.gnome.TextEditor"
            "org.inkscape.Inkscape"
            "org.onlyoffice.desktopeditors"
            "org.telegram.desktop"
            "page.tesk.Refine"
        ];
    };

    system.stateVersion = "26.05";
}