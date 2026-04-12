{ pkgs, ... }: {
    dconf.settings = {
        "org/gnome/desktop/interface" = {
            monospace-font-name = "Iosevka Extended 11";
        };
    };
}