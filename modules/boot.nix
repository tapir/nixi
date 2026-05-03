{ ... }:

{
  boot = {
    loader = {
      systemd-boot.enable = true;
      systemd-boot.consoleMode = "max";
      systemd-boot.configurationLimit = 5;
      efi.canTouchEfiVariables = true;
    };

    consoleLogLevel = 3;

    initrd = {
      verbose = false;
    };

    kernelParams = [
      "quiet"
      "udev.log_level=3"
      "systemd.show_status=auto"
    ];
  };
}
