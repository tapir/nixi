{ pkgs, home-manager, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/boot.nix
    ../../modules/base.nix
    ../../modules/nvidia.nix
    ../../modules/kernel-xanmod.nix
    ../../modules/steam.nix
    ../../modules/scx-bpfland.nix
    ../../modules/embedded.nix
    ../../modules/kmscon.nix
    ../../modules/containers.nix
    ../../modules/jumper-t-lite.nix
  ];

  system.stateVersion = "26.05";
  home-manager.users.cosku = import ./home.nix;
  networking.hostName = "nixcosh-desktop";

  # Desktop specific packages
  environment.systemPackages = with pkgs; [
    oscar
  ];

  # Desktop specific flatpaks
  services.flatpak = {
    packages = [
      "com.discordapp.Discord"
      "com.bambulab.BambuStudio"
    ];
  };
}
