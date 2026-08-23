{ pkgs, home-manager, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/boot.nix
    ../../modules/base.nix
    ../../modules/intel.nix
    ../../modules/kernel-xanmod.nix
    ../../modules/steam.nix
    ../../modules/scx-bpfland.nix
    ../../modules/embedded.nix
    ../../modules/kmscon.nix
    ../../modules/containers.nix
  ];

  system.stateVersion = "26.05";
  home-manager.users.cosku = import ./home.nix;
  networking.hostName = "nixcosh-minipc";

  # Minipc specific packages
  # environment.systemPackages = with pkgs; [
  # ];

  # Minipc specific flatpaks
  services.flatpak = {
    packages = [
      "com.discordapp.Discord"
      "org.blender.Blender"
      "org.kicad.KiCad"
      "org.godotengine.Godot"
      "com.bambulab.BambuStudio"
      "com.orcaslicer.OrcaSlicer"
    ];
  };
}
