{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    qmk
    qmk-udev-rules
    via
  ];

  hardware.keyboard.qmk.enable = true;
  services.udev = {
    packages = with pkgs; [
      qmk
      qmk-udev-rules
      via
    ];
  };
}
