{ pkgs, ... }:

{
  services.xserver.videoDrivers = [ "modesetting" ];

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
      # VA-API drivers for the Intel iGPU (video decode/encode)
      extraPackages = with pkgs; [
        intel-media-driver
        intel-vaapi-driver
      ];
    };
  };

  boot.initrd.kernelModules = [ "i915" ];
}
