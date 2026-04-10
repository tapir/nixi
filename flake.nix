{
    description = "NixOS config";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
        nix-flatpak.url = "github:gmodena/nix-flatpak/v0.7.0";
        nix-flatpak.inputs.nixpkgs.follows = "nixpkgs";
    };

    outputs = { self, nixpkgs, nix-flatpak, ... }:
    let
        system = "x86_64-linux";
    in {
        nixosConfigurations = {
            desktop = nixpkgs.lib.nixosSystem {
                inherit system;
                modules = [
                    ./hosts/desktop.nix

                    nix-flatpak.nixosModules.nix-flatpak
                    ./modules/flatpak-desktop.nix
                ];
            };

            laptop = nixpkgs.lib.nixosSystem {
                inherit system;
                modules = [
                    ./hosts/laptop.nix

                    nix-flatpak.nixosModules.nix-flatpak
                    ./modules/flatpak-laptop.nix
                ];
            };
        };
    };
}