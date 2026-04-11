{ ... }:

{
    imports = [
        ./hardware-configuration.nix
        ../../modules/boot.nix
        ../../modules/base.nix
        ../../modules/packages.nix
        ../../modules/amd.nix
    ];

    networking.hostName = "nixcosh-laptop";

    #environment.systemPackages = with pkgs; [ ];

    services.scx = {
        enable = true;
        scheduler = "scx_bpfland";
        extraArgs = [
            "-s 20000"
            "-m powersave"
            "-I 100"
            "-t 100"
        ];
    };

    services.flatpak = {
        enable = true;
        packages = [
            "com.slack.Slack"
            "io.github.kolunmi.Bazaar"
            "com.github.tchx84.Flatseal"
            "com.mattjakeman.ExtensionManager"
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
            "org.gtk.Gtk3theme.adw-gtk3"
            "org.gtk.Gtk3theme.adw-gtk3-dark"
        ];
    };

    system.stateVersion = "26.05";
}