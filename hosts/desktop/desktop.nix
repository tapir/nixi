{ pkgs, home-manager, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/boot.nix
    ../../modules/base.nix
    ../../modules/packages.nix
    ../../modules/nvidia.nix
    ../../modules/kernel-xanmod.nix
  ];

  system.stateVersion = "26.05";

  home-manager.users.cosku = import ./home.nix;

  networking.hostName = "nixcosh-desktop";

  services.scx = {
    enable = true;
    scheduler = "scx_bpfland";
    extraArgs = [
      "-m performance"
      "-w"
    ];
  };

  services.flatpak = {
    packages = [
      "com.discordapp.Discord"
      "com.bambulab.BambuStudio"
    ];
  };

  environment.systemPackages = with pkgs; [
    steam
  ];
}
