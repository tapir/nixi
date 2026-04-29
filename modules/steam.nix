{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    mangohud
    gamemode
  ];

  programs.steam = {
    enable = true;
    extraCompatPackages = [ pkgs.proton-ge-bin ];
  };

  boot.kernelModules = [ "ntsync" ];

  environment.sessionVariables = {
    PROTON_USE_NTSYNC = "1";
    SDL_VIDEODRIVER = "wayland";
    SDL_VIDEO_DRIVER = "wayland";
    SDL_AUDIODRIVER = "pipewire";
    SDL_AUDIO_DRIVER = "pipewire";
  };

  environment.etc."MangoHud/MangoHud.conf".text = ''
    fps
    fps_metrics=avg,0.01
    cpu_stats
    gpu_stats
    cpu_load_change
    gpu_load_change
  '';
}
