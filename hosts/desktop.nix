{ ... }:

{
    imports = [
        ./hardware-configuration.nix
        ../modules/boot.nix
        ../modules/base.nix
        ../modules/packages.nix
        ../modules/nvidia.nix
    ];

    networking.hostName = "nixcosh-desktop";

    system.stateVersion = "26.05";
}