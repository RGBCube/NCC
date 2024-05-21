{ config, lib, ... }: with lib;

desktopUserHomeConfiguration {
  wayland.windowManager.hyprland.settings = {
    bindl = [(replaceStrings [ "\n;" "\n" ] [ ";" "" ] ''
      , XF86PowerOff, exec,
      pkill fuzzel;
      echo -en "Suspend\0icon\x1fsystem-suspend\nHibernate\0icon\x1fsystem-suspend-hibernate-alt2\nPower Off\0icon\x1fsystem-shutdown\nReboot\0icon\x1fsystem-reboot"
      | fuzzel --dmenu
      | tr --delete " "
      | tr '[:upper:]' '[:lower:]'
      | ifne xargs systemctl
    '')];

    bind = [
      "SUPER, SPACE, exec, pkill fuzzel; fuzzel"
      "SUPER, V    , exec, pkill fuzzel; cliphist list | fuzzel --dmenu | cliphist decode | wl-copy"
    ];
  };

  programs.fuzzel = with config.theme; enabled {
    settings.main = {
      dpi-aware  = false;
      font       = "${font.sans.name}:size=${toString font.size.big}";
      icon-theme = icons.name;

      layer     = "overlay";
      prompt    = ''"❯ "'';

      terminal = "ghostty -e";

      tabs = 4;

      horizontal-pad = padding;
      vertical-pad   = padding;
      inner-pad      = padding;
    };

    settings.colors = mapAttrs (_: color: color + "FF") {
      background     = base00;
      text           = base05;
      match          = base0A;
      selection      = base05;
      selection-text = base00;
      border         = base0A;
    };

    settings.border = {
      radius = cornerRadius;
      width  = borderWidth;
    };
  };
}
