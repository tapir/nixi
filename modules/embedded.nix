{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    openocd
  ];

  services.udev.packages = [ pkgs.openocd ];
  users = {
    groups.plugdev = { };
    users.cosku.extraGroups = [
      "plugdev"
      "dialout"
    ];
  };
}
