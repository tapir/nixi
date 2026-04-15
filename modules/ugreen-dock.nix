{ pkgs, ... }:
{
  # Rename the dongle to usbeth0 based on MAC
  systemd.network.links."10-usbeth0" = {
    matchConfig.MACAddress = "6c:1f:f7:75:07:ae";
    linkConfig.Name = "usbeth0";
  };

  # Apply ethtool tuning when the device appears
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="net", ATTR{address}=="6c:1f:f7:75:07:ae", \
      RUN+="${pkgs.ethtool}/bin/ethtool --set-eee usbeth0 eee off"

    # Disable autosuspend on the RTL8153 ethernet itself
    ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="0bda", ATTR{idProduct}=="8153", \
      ATTR{power/control}="on", ATTR{power/autosuspend}="-1"
  '';
}
