{ config, ... }:

{
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };

    nvidia = {
      # ponytail: nixpkgs production (595.x) doesn't compile on kernel 7.2 (strncpy removed);
      # latest (610.57.04) does. Drop this line when nixpkgs production catches up.
      package = config.boot.kernelPackages.nvidiaPackages.latest;
      open = true;
      modesetting.enable = true;
      powerManagement.enable = true;
    };

    nvidia-container-toolkit.enable = true;
  };

  boot.initrd.kernelModules = [
    "nvidia"
    "nvidia_modeset"
    "nvidia_uvm"
    "nvidia_drm"
  ];
}
