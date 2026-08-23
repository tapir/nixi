{ ... }:

{
  services.udev.extraRules = ''
    SUBSYSTEM=="hidraw", ATTRS{idVendor}=="3151", MODE="0666" 
  '';
}
