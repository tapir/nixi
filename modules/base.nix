{ pkgs, ... }:

{
  # Enable flakes
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Global env vars
  environment.sessionVariables = {
    SHELL = "${pkgs.bash}/bin/bash";
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
    DISTROBOX_CONTAINER_MANAGER = "docker";
    MOZ_ENABLE_WAYLAND = "1";
  };

  # Locale
  time.timeZone = "Europe/Amsterdam";
  i18n = {
    defaultLocale = "en_GB.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "nl_NL.UTF-8";
      LC_IDENTIFICATION = "nl_NL.UTF-8";
      LC_MEASUREMENT = "nl_NL.UTF-8";
      LC_MONETARY = "nl_NL.UTF-8";
      LC_NAME = "en_GB.UTF-8";
      LC_NUMERIC = "en_GB.UTF-8";
      LC_PAPER = "en_GB.UTF-8";
      LC_TELEPHONE = "nl_NL.UTF-8";
      LC_TIME = "en_GB.UTF-8";
    };
  };

  # User settings
  users.users.cosku = {
    isNormalUser = true;
    description = "cosku";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  # Desktop stuff
  services = {
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    xserver = {
      enable = true;
      xkb.layout = "tr";
      excludePackages = with pkgs; [ xterm ];
    };
  };

  # Global NixOS packages
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
      resources
      iosevka
      nixfmt
      nixd
      p7zip
      exfatprogs
      # xeyes
      # usbutils
      # pciutils
      # acpica-tools
    ];
  };

  # Global flatpaks
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
      "io.github.tobagin.karere"
    ];

    overrides.global = {
      Context.filesystems = [
        "xdg-config/gtk-3.0:ro"
        "xdg-config/gtk-4.0:ro"
      ];
    };
  };

  # AppImage
  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  # NetworkManager
  networking.networkmanager.enable = true;

  # Unfree packages
  nixpkgs.config.allowUnfree = true;

  # Firmware service
  services.fwupd.enable = true;

  # Remove NixOS menu items
  documentation.nixos.enable = false;

  # Audio
  security.rtkit.enable = true;
  services = {
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
  };

  # Optimize disk size
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
  nix.settings.auto-optimise-store = true;
}
