{ pkgs, ... }:

{
    # Enable flakes
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

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
        extraGroups = [ "networkmanager" "wheel" "docker" ];
    };

    # Audio
    security.rtkit.enable = true;
}