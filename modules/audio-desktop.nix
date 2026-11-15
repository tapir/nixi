{ pkgs, ... }:

let
  # The rear line-out's presence switch never closes on this board: the codec
  # reports the jack empty with a cable in, so ACP marks the port unavailable,
  # never applies its mixer path (Master stays muted at 0) and the desktop
  # hides the card. 0x100 in the pin default config is the "no presence
  # detect" bit, turning the jack into a phantom one that ALSA always reports
  # as plugged: BIOS value 0x01014010 -> 0x01014110.
  lineOutNoPresence = (
    pkgs.writeTextDir "lib/firmware/alc1220-lineout-nopresence.hda" ''
      [codec]
      0x10ec1168 0x104388b9 0

      [pincfg]
      0x14 0x01014110
    ''
  ) // {
    compressFirmware = false;
  };
in
{
  hardware.firmware = [ lineOutNoPresence ];

  # patch= is indexed by HDA card instance. The onboard lands on card 0 because
  # the GPU's audio function is removed before snd_hda_intel loads, but the
  # entry is repeated so a probe-order change cannot silently drop the fix.
  boot.extraModprobeConfig = ''
    options snd_hda_intel patch=alc1220-lineout-nopresence.hda,alc1220-lineout-nopresence.hda
  '';

  # The GPU's HDMI/DP audio function is unused; dropping it at the PCI level
  # keeps it out of PipeWire, the sound panel and the HDA card numbering.
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x040300", ATTR{remove}="1"
  '';

  services.pipewire.wireplumber.extraConfig."51-audio-devices" = {
    # Profiles are pinned below, so a remembered one must not win over them.
    "wireplumber.settings"."device.restore-profile" = false;

    # ALC1220: analog output only — the fifine USB mic is the sole source.
    "device.profile.priority.rules" = [
      {
        matches = [ { "device.name" = "alsa_card.pci-0000_0c_00.6"; } ];
        actions.update-props.priorities = [ "output:analog-stereo" ];
      }
    ];

    # ACP drops whatever is listed here from the Pulse API: hidden profiles
    # cannot be selected at all, and the UI devices GNOME derives from card
    # ports are never created. This is the only way to remove a direction —
    # snd-usb-audio builds both PCMs from the descriptors, so unbinding the
    # playback interface leaves the output in place.
    "monitor.alsa.rules" = [
      {
        matches = [ { "device.name" = "alsa_card.pci-0000_0c_00.6"; } ];
        actions.update-props = {
          # pro-audio would expose the raw capture PCM again
          "api.acp.disable-pro-audio" = "true";
          "api.acp.hidden-ports" = ''
            [ "analog-input-front-mic", "analog-input-rear-mic", "analog-input-linein" ]
          '';
          "api.acp.hidden-profiles" = ''
            [ "input:analog-stereo", "input:iec958-stereo"
            , "output:analog-stereo+input:analog-stereo"
            , "output:analog-stereo+input:iec958-stereo"
            , "output:iec958-stereo+input:analog-stereo"
            , "output:iec958-stereo+input:iec958-stereo"
            , "output:analog-surround-21+input:analog-stereo"
            , "output:analog-surround-41+input:analog-stereo"
            , "output:analog-surround-51+input:analog-stereo"
            , "output:analog-surround-40+input:analog-stereo"
            , "output:analog-surround-50+input:analog-stereo" ]
          '';
        };
      }
      {
        matches = [ { "device.name" = "alsa_card.usb-3142_fifine_Microphone-00"; } ];
        actions.update-props = {
          # pro-audio would expose the raw playback PCM again
          "api.acp.disable-pro-audio" = "true";
          # capture only, and analog only: no output ports, no S/PDIF input
          "api.acp.hidden-ports" = ''
            [ "analog-output-speaker", "iec958-stereo-output", "iec958-stereo-input" ]
          '';
          "api.acp.hidden-profiles" = ''
            [ "output:analog-stereo", "output:iec958-stereo"
            , "output:analog-stereo+input:analog-stereo"
            , "output:analog-stereo+input:iec958-stereo"
            , "output:iec958-stereo+input:analog-stereo"
            , "output:iec958-stereo+input:iec958-stereo"
            , "input:iec958-stereo" ]
          '';
        };
      }
    ];
  };
}
