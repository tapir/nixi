{ ... }:

{
  # The GPU's HDMI/DP audio function is unused; dropping it at the PCI level
  # keeps it out of PipeWire and the sound panel entirely.
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x040300", ATTR{remove}="1"
  '';

  services.pipewire.wireplumber.extraConfig."51-audio-devices" = {
    # Profiles are pinned below, so a remembered one must not win over them.
    "wireplumber.settings"."device.restore-profile" = false;

    # ALC1220: analog output only — the fifine USB mic is the sole source.
    # fifine: capture only, its headphone output stays out of the menu.
    "device.profile.priority.rules" = [
      {
        matches = [ { "device.name" = "alsa_card.pci-0000_0c_00.6"; } ];
        actions.update-props.priorities = [ "output:analog-stereo" ];
      }
      {
        matches = [ { "device.name" = "alsa_card.usb-3142_fifine_Microphone-00"; } ];
        actions.update-props.priorities = [ "input:analog-stereo" ];
      }
    ];
  };
}
