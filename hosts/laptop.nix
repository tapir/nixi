{ ... }:

{
    imports = [
        ./hardware-configuration.nix
        ../modules/boot.nix
        ../modules/base.nix
        ../modules/packages.nix
        ../modules/amd.nix
    ];

    networking.hostName = "nixcosh-laptop";

    system.stateVersion = "26.05";
}