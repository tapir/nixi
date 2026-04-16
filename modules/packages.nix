{ pkgs, ... }:

{
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
  };

  environment = {
    gnome.excludePackages = with pkgs; [
      gnome-tour
      epiphany
      totem
      showtime
      geary
      yelp
      gnome-browser-connector
      gnome-calendar
      gnome-connections
      gnome-contacts
      gnome-characters
      seahorse
      gnome-maps
      gnome-music
      gnome-weather
      gnome-software
      gnome-font-viewer
      snapshot
      gnome-console
      simple-scan
      decibels
      gnome-clocks
      loupe
      papers
      gnome-logs
      gnome-calculator
      baobab
      gnome-text-editor
      gnome-system-monitor
    ];
    systemPackages = with pkgs; [
      podman-compose
      distrobox
      vscode
      scx.full
      ptyxis
      google-chrome
      firefox
      git
      adw-gtk3
      resources
      iosevka
      nixfmt
      usbutils
      pciutils
      ethtool
      acpica-tools
    ];
  };

  services.flatpak = {
    enable = true;
    packages = [
      "io.github.kolunmi.Bazaar"
      "com.github.tchx84.Flatseal"
      "com.mattjakeman.ExtensionManager"
      "com.ranfdev.DistroShelf"
      "io.dbeaver.DBeaverCommunity"
      "io.github.celluloid_player.Celluloid"
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
      "org.gtk.Gtk3theme.adw-gtk3"
      "org.gtk.Gtk3theme.adw-gtk3-dark"
      "ca.desrt.dconf-editor"
    ];
  };
}
