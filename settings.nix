{ ... }:
{
  de = {
    plasma = true;
  };
  wm = {
    i3 = false;
  };

  virtualization = {
    # Devices that will be disabled and ready for passthorugh
    # Remember to disable gpu in bios (change display)
    passthrough = {
      enable = false;
      # Ids can be read from `lspci -nnk`
      gpu = {
        enable = true;
        ids1 = [ "0000:01:00.0" "0000:01:00.1" ];
        ids2 = [ "1002:67df" "1002:aaf0" ];
      };
      audio-card = {
        enable = false;
        ids1 = [ "0000:00:1b.0" ];
        ids2 = [ "8086:8c20" ];
      };
    };

    # Needed if acs are not valid
    acs-override-patch = false;
  };
}
