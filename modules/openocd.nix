{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    openocd
  ];

  services.udev.packages = [ pkgs.openocd ];
  users.users.cosku.extraGroups = [ "plugdev" ];
}
