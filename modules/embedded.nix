{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    openocd
    inetutils
    sunxi-tools
  ];

  # ST-Link V2 adapter and sunxi-fel
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3748", MODE="0666", GROUP="plugdev"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="1f3a", ATTRS{idProduct}=="efe8", MODE="0666", GROUP="plugdev"
  '';

  services.udev.packages = [ pkgs.openocd ];
  users = {
    groups.plugdev = { };
    users.cosku.extraGroups = [
      "plugdev"
    ];
  };
}
