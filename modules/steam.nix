{ pkgs, ... }:

{
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
}
