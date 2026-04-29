{ pkgs, home-manager, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/boot.nix
    ../../modules/base.nix
    ../../modules/packages.nix
    ../../modules/nvidia.nix
    ../../modules/kernel-xanmod.nix
    ../../modules/steam.nix
    ../../modules/scx-bpfland.nix
  ];

  system.stateVersion = "26.05";
  home-manager.users.cosku = import ./home.nix;
  networking.hostName = "nixcosh-desktop";

  # Desktop specific packages
  environment.systemPackages = with pkgs; [
    mangohud
    gamemoderun
  ];

  # Desktop specific flatpaks
  services.flatpak = {
    packages = [
      "com.discordapp.Discord"
      "com.bambulab.BambuStudio"
    ];
  };
}
