{
    description = "NixOS config";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
        nix-flatpak.url = "github:gmodena/nix-flatpak/v0.7.0";
        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = { self, nixpkgs, nix-flatpak, home-manager, ... }:
    let
        system = "x86_64-linux";
    in {
        nixosConfigurations = {
            desktop = nixpkgs.lib.nixosSystem {
                inherit system;
                modules = [
                    ./hosts/desktop/desktop.nix

                    nix-flatpak.nixosModules.nix-flatpak

                    home-manager.nixosModules.home-manager
                    ./modules/home-manager.nix
                ];
            };

            laptop = nixpkgs.lib.nixosSystem {
                inherit system;
                modules = [
                    ./hosts/laptop/laptop.nix

                    nix-flatpak.nixosModules.nix-flatpak

                    home-manager.nixosModules.home-manager
                    ./modules/home-manager.nix
                ];
            };
        };
    };
}