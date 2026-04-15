{ pkgs, ... }:
{
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="net", ATTR{address}=="6c:1f:f7:75:07:ae", \
      RUN+="${pkgs.ethtool}/bin/ethtool --set-eee usbeth0 eee off", \
      RUN+="${pkgs.ethtool}/bin/ethtool -K usbeth0 tso off gso off gro off"
  '';
}
