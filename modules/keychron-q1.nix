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

  services.udev.extraRules = ''
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="3434", ATTRS{idProduct}=="0810", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl" 
  '';
}
