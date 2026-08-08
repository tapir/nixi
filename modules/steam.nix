{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    mangohud
    gamemode
  ];

  programs.steam.enable = true;

  services.flatpak = {
    packages = [
      "com.vysp3r.ProtonPlus"
    ];
  };

  boot.kernelModules = [ "ntsync" ];

  environment.sessionVariables = {
    PROTON_USE_NTSYNC = "1";
    PROTON_DXVK_LOWLATENCY = 1;
    SDL_AUDIODRIVER = "pipewire";
    SDL_AUDIO_DRIVER = "pipewire";
  };
}
