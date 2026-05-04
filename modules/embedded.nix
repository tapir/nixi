{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    openocd
  ];

  # ST-Link V2 adapter
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3748", MODE="0666", GROUP="plugdev"
  '';

  services.udev.packages = [ pkgs.openocd ];
  users = {
    groups.plugdev = { };
    users.cosku.extraGroups = [
      "plugdev"
      "dialout"
    ];
  };
}
