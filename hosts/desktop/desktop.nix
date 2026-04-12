{ pkgs, home-manager, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/boot.nix
    ../../modules/base.nix
    ../../modules/packages.nix
    ../../modules/nvidia.nix
  ];

  networking.hostName = "nixcosh-desktop";

  environment.systemPackages = with pkgs; [
    steam
  ];

  home-manager.users.cosku = import ./home.nix;

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
      "com.orcaslicer.OrcaSlicer"
    ];
  };

  system.stateVersion = "26.05";
}
