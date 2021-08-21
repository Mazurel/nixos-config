# This is my custom settings file
#
# It contains some settings and customizations
# that are supposed to be morew high level
# than configuring files
#
# Some settings are for home-manager and some
# are for system-wide configuration
{
  # This settings are single user oriented
  # below there is main (non-root) username
  user = "mateusz";

  # You should have only one de/wm selected 
  de = {
    plasma = false;
    gnome = false;
  };
  wm = {
    i3 = false;
    dwm = false;
    leftwm = true;
  };

  editors = {
    emacs = true;
    neovim = true;
  };

  development = { java = false; };

  virtualization = {
    enable = true;
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
