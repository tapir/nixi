{ pkgs, ... }:

{
  boot = {
    # Bootloader
    loader = {
      systemd-boot.enable = true;
      systemd-boot.consoleMode = "max";
      systemd-boot.configurationLimit = 5;
      efi.canTouchEfiVariables = true;
    };

    # Boot animation
    plymouth = {
      enable = true;
      theme = "sliced";
      themePackages = with pkgs; [
        (adi1090x-plymouth-themes.override {
          selected_themes = [ "sliced" ];
        })
      ];
    };

    # Silence boot messages
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
