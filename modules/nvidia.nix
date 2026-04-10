{ ... }:

{
    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.graphics = {
        enable = true;
        enable32Bit = true;
    };

    hardware.nvidia = {
        open = true;
        modesetting.enable = true;
        powerManagement.enable = true;
    };

    hardware.nvidia-container-toolkit.enable = true;

    boot.initrd.kernelModules = [
        "nvidia"
        "nvidia_modeset"
        "nvidia_uvm"
        "nvidia_drm"
    ];
}