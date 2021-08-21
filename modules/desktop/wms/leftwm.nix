{ pkgs, config, lib, ... }:
let
  cfg = config.mazurel.xorg.wms.leftwm;

  # This is used for my leftwm config
  #
  # TODO: Add dictionaries and multiline strings, see https://toml.io/en/
  configtoTOML = cfg:
    let
      commandSpacing = "\n";

      tomlToString = val:
        let type = builtins.typeOf val;
        in if type == "list" then
          "[ ${
            builtins.concatStringsSep ", " (builtins.map tomlToString val)
          } ]"
        else if type == "string" then
          ''"${val}"''
        else if type == "int" || type == "float" || type == "bool" then
          "${val}"
        else
          abort ''Type "${type}" is not supported'';

      parseSetting = setting:
        let
          stringedAttrs = with builtins;
            map (name: "${name} = ${tomlToString setting.${name}}")
            (attrNames (removeAttrs setting [ "section" ]));
        in ''
          ${if setting ? section then "[[${setting.section}]]" else ""}
          ${with pkgs;
          lib.foldl (acc: val: ''
            ${acc}${val}
          '') "" stringedAttrs}
        '';
    in with pkgs;
    lib.foldl (acc: val: "${acc}${parseSetting val}${commandSpacing}") "" cfg;

in {
  options.mazurel.xorg.wms.leftwm.enable =
    lib.mkEnableOption "Enable my default leftwm config";

  config = lib.mkIf cfg.enable {
    mazurel.xorg.wms.common.xautolock.enable = true;
    mazurel.xorg.wms.common.packages.enable = true;
    mazurel.xorg.wms.common.picom.enable = true;

    services.xserver = {
      enable = true;

      displayManager.lightdm.enable = true;
      windowManager.leftwm.enable = true;
    };

    mazurel.home-manager = {
      xdg.configFile."leftwm/test-config.toml".text = configtoTOML ([
        {
          modkey = "Mod4";
          workspaces = [ ];
          tags = [ "I" "II" "III" "IV" "V" "VI" "VII" "VIII" "IX" ];
          layout =
            [ "MainAndVertStack" "LeftWiderRightStack" "Monocle" "CenterMain" ];
        }
        {
          section = "keybind";
          command = "Execute";
          value = "rofi -show drun";
          modifier = [ "modkey" ];
          key = "p";
        }
        {
          section = "keybind";
          command = "Execute";
          value = "rofi -show run";
          modifier = [ "modkey" "Shift" ];
          key = "p";
        }
      ] ++ pkgs.lib.flatten (builtins.map (ws: [
        {
          section = "keybind";
          command = "GotoTag";
          modifier = [ "modkey" ];
          key = ws;
          value = ws;
        }
        {
          section = "keybind";
          command = "MoveToTag";
          modifier = [ "modkey" "Shift" ];
          key = ws;
          value = ws;
        }
      ]) [ "1" "2" "3" "4" "5" "6" "7" "8" "9" ]));
    };
  };
}
