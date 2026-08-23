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
    ../../modules/epomaker-th80v2.nix
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
      "com.orcaslicer.OrcaSlicer"
      "org.ardour.Ardour"
      "org.freedesktop.LinuxAudio.Plugins.ArtyFX//25.08"
      "org.freedesktop.LinuxAudio.Plugins.ChowTapeModel//25.08"
      "org.freedesktop.LinuxAudio.Plugins.DragonflyReverb//25.08"
      "org.freedesktop.LinuxAudio.Plugins.peakeater//25.08"
      "org.freedesktop.LinuxAudio.Plugins.Airwindows//25.08"
      "org.freedesktop.LinuxAudio.Plugins.BYOD//25.08"
      "org.freedesktop.LinuxAudio.Plugins.ChowDSP-Plugins//25.08"
      "org.freedesktop.LinuxAudio.Plugins.InfamousPlugins//25.08"
      "org.freedesktop.LinuxAudio.Plugins.LSP//25.08"
      "org.freedesktop.LinuxAudio.Plugins.NeuralAmpModeler//25.08"
      "org.freedesktop.LinuxAudio.Plugins.WolfShaper//25.08"
      "org.freedesktop.LinuxAudio.Plugins.noise-repellent//25.08"
      "org.freedesktop.LinuxAudio.Plugins.x42Plugins//25.08"
      "org.freedesktop.LinuxAudio.Plugins.Guitarix//25.08"
    ];
  };
}
