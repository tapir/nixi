{ ... }:

{
  services.udev.extraRules = ''
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="3434", MODE="0666", GROUP="users", TAG+="uaccess", TAG+="udev-acl" 
  '';
}
