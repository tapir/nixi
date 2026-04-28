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
  ];

  system.stateVersion = "26.05";
  home-manager.users.cosku = import ./home.nix;
  networking.hostName = "nixcosh-desktop";

  # Scheduler for game performance
  services.scx = {
    enable = true;
    scheduler = "scx_bpfland";
    extraArgs = [
      "-m performance"
      "-w"
    ];
  };

  # Desktop specific flatpaks
  services.flatpak = {
    packages = [
      "com.discordapp.Discord"
      "com.bambulab.BambuStudio"
    ];
  };
}
