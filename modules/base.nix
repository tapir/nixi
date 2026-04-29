{ pkgs, ... }:

{
  # Enable flakes
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

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

  # Desktop stuff
  services = {
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    xserver = {
      enable = true;
      xkb.layout = "tr";
    };
  };

  # Firmware service
  services.fwupd.enable = true;

  # NetworkManager
  networking.networkmanager.enable = true;

  # Unfree packages
  nixpkgs.config.allowUnfree = true;

  # Turkish Q keyboard layout
  console.keyMap = "trq";

  # Remove NixOS menu items
  documentation.nixos.enable = false;

  # Optimize disk size
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
  nix.settings.auto-optimise-store = true;

  # User settings
  users.users.cosku = {
    isNormalUser = true;
    description = "cosku";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "podman"
    ];
  };

  # Global env vars
  environment.sessionVariables = {
    SHELL = "${pkgs.bash}/bin/bash";
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
    DISTROBOX_CONTAINER_MANAGER = "docker";
    MOZ_ENABLE_WAYLAND = "1";
  };

  # Docker and podman setup
  virtualisation = {
    docker.enable = true;
    docker.daemon.settings.features.cdi = true;

    containers.enable = true;
    podman = {
      enable = true;
      dockerCompat = false;
      defaultNetwork.settings.dns_enabled = true;
    };
  };
  systemd.user.sockets.podman.wantedBy = [ "sockets.target" ];

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

}
