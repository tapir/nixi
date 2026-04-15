{ pkgs, ... }:
{
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="net", ATTR{address}=="6c:1f:f7:75:07:ae", \
      RUN+="${pkgs.ethtool}/bin/ethtool --set-eee $env{INTERFACE} eee off", \
      RUN+="${pkgs.ethtool}/bin/ethtool -K $env{INTERFACE} tso off gso off gro off"
  '';
}
