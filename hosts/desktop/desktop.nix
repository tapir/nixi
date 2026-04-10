{ pkgs, ... }:

{
    imports = [
        ./hardware-configuration.nix
        ./flatpak.nix
        ../../modules/boot.nix
        ../../modules/base.nix
        ../../modules/packages.nix
        ../../modules/nvidia.nix
    ];

    networking.hostName = "nixcosh-desktop";

    environment.systemPackages = with pkgs; [
        steam
    ];

    system.stateVersion = "26.05";
}