{ pkgs, ... }:

{
    environment.sessionVariables = {
        SHELL = "${pkgs.bash}/bin/bash";
        WLR_NO_HARDWARE_CURSORS = "1";
    };

    virtualisation = {
        docker.enable = true;
        docker.daemon.settings.features.cdi = true;
        podman.enable = true;
    };

    services = {
        displayManager.gdm.enable = true;
        desktopManager.gnome.enable = true;
        xserver = {
            enable = true;
            excludePackages = with pkgs; [ xterm ];
            xkb.layout = "tr";
        };
        fwupd.enable = true;
        pulseaudio.enable = false;
        pipewire = {
            enable = true;
            alsa.enable = true;
            alsa.support32Bit = true;
            pulse.enable = true;
            jack.enable = true;
        };
        scx = {
            enable = true;
            scheduler = "scx_bpfland";
        };
    };

    environment = {
        gnome.excludePackages = with pkgs; [
            gnome-tour epiphany totem showtime geary yelp
            gnome-browser-connector gnome-calendar gnome-connections
            gnome-contacts gnome-characters seahorse gnome-maps
            gnome-music gnome-weather gnome-software gnome-font-viewer
            snapshot gnome-console simple-scan decibels gnome-clocks
            loupe papers gnome-logs gnome-calculator baobab
            gnome-text-editor gnome-system-monitor
        ];
        systemPackages = with pkgs; [
            distrobox
            vscode
            zed-editor
            scx.full
            ptyxis
            google-chrome
            firefox
            git
        ];
    };
}