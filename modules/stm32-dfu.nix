{
  services.udev.extraRules = ''
    # Boxer (and all EdgeTX radios) in STM32 DFU mode
    SUBSYSTEM=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="df11", MODE="0666"
  '';
}
