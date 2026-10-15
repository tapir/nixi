{ ... }:

{
  services.udev.extraRules = ''
    SUBSYSTEM=="hidraw", ATTRS{idVendor}=="0a12", MODE="0666" 
  '';
}
