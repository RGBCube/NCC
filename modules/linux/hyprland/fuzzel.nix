{ config, lib, ... }: let
  inherit (lib) enabled mapAttrs merge mkIf replaceStrings;
in merge <| mkIf config.isDesktop {
  home-manager.sharedModules = [{
    wayland.windowManager.hyprland.settings = {
      bindl = [(replaceStrings [ "\n;" "\n" ] [ ";" "" ] /* sh */ ''
        , XF86PowerOff, exec,
        pkill fuzzel;
        echo -en "Suspend\0icon\x1fsystem-suspend\nHibernate\0icon\x1fsystem-suspend-hibernate-alt2\nPower Off\0icon\x1fsystem-shutdown\nReboot\0icon\x1fsystem-reboot"
        | fuzzel --dmenu
        | tr --delete " "
        | tr '[:upper:]' '[:lower:]'
        | ifne xargs systemctl
      '')];

      bind = [
        "SUPER    , SPACE, exec, pkill fuzzel; fuzzel"
        "SUPER    , E    , exec, pkill fuzzel; cat ${./emojis.txt} | fuzzel --no-fuzzy --dmenu | cut -d ' ' -f 1 | tr -d '\\n' | wl-copy"
        "SUPER+ALT, E    , exec, pkill fuzzel; cat ${./emojis.txt} | fuzzel --no-fuzzy --dmenu | cut -d ' ' -f 1 | tr -d '\\n' | wtype -"
        "SUPER    , V    , exec, pkill fuzzel; cliphist list | fuzzel --dmenu | cliphist decode | wl-copy"
      ];
    };

    services.cliphist = enabled {
      extraOptions = [ "-max-items" "1000" ];
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
  }];
}
