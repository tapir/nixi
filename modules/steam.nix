{ pkgs, ... }:

{
  programs.steam = {
    enable = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };

  boot.kernelModules = [ "ntsync" ];

  environment.sessionVariables = {
    PROTON_USE_NTSYNC = "1";
  };
}
