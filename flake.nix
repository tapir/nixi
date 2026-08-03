{
  description = "NixOS config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nix-flatpak.url = "github:gmodena/nix-flatpak/v0.7.0";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # 1. Added claude-desktop here
    claude-desktop.url = "github:aaddrick/claude-desktop-debian";
  };

  outputs =
    {
      self,
      nixpkgs,
      nix-flatpak,
      home-manager,
      ...
    }@inputs: # 2. Added @inputs to capture them for specialArgs
    let
      system = "x86_64-linux";
    in
    {
      nixosConfigurations = {
        desktop = nixpkgs.lib.nixosSystem {
          inherit system;
          # 3. Pass inputs to desktop modules
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/desktop/system.nix

            nix-flatpak.nixosModules.nix-flatpak

            home-manager.nixosModules.home-manager
            ./modules/home-manager.nix
          ];
        };

        laptop = nixpkgs.lib.nixosSystem {
          inherit system;
          # 3. Pass inputs to laptop modules
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/laptop/system.nix

            nix-flatpak.nixosModules.nix-flatpak

            home-manager.nixosModules.home-manager
            ./modules/home-manager.nix
          ];
        };
      };
    };
}
