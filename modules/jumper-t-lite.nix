{ ... }:

{
  users = {
    users.cosku.extraGroups = [
      "dialout"
    ];
  };

  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="df11", MODE="0666", GROUP="dialout"
  '';
}
