{ upkgs, homeConfiguration, enabled, ... }:

homeConfiguration "nixos" {
  programs.waybar = enabled {
    systemd = enabled {};

    settings = [{
      layer  = "top";
      height = 30;

      margin-right = 10;
      margin-left  = 10;
      margin-top   = 10;

      modules-left = [
        "hyprland/workspaces"
      ];

      "hyprland/workspaces" = {
        format               = "{icon}";
        format-icons.default = "";
        format-icons.active  = "";

        persistent-workspaces."*" = 5;
      };

      modules-center = [
        "hyprland/window"
      ];

      "hyprland/window" = {
        seperate-outputs = true;

        rewrite."(.*) - Discord"         = "󰙯 $1";
        rewrite."(.*) — Mozilla Firefox" = "󰖟 $1";
        rewrite."(.*) — nu"              = " $1";
      };

      modules-right = [
        "tray"
        "pulseaudio"
        "backlight"
        "cpu"
        "memory"
        "network"
        "battery"
        "clock"
      ];

      pulseaudio = {
        format                 = "{format_source} {icon} {volume}%";
        format-bluetooth       = "{format_source} {icon}󰂯 {volume}%";
        format-bluetooth-muted = "{format_source} 󰝟 {icon}󰂯";
        format-muted           = "{format_source} 󰝟";
        format-source          = "󰍬";
        format-source-muted    = "󰍭";

        format-icons.headphone = "󰋋";
        format-icons.headset   = "󰋋";
        format-icons.default = [
          "󰕿"
          "󰖀"
          "󰕾"
        ];
      };

      backlight =  {
        format       = "{icon} {percent}%";
        format-icons = [
          ""
          ""
          ""
          ""
          ""
          ""
          ""
          ""
          ""
        ];
      };

      cpu.format    = " {usage}%";
      memory.format = " {}%";

      network = {
        format-disconnected = "󰤮";
        format-ethernet     = "󰈀 {ipaddr}/{cidr}";
        format-linked       = " {ifname} (No IP)";
        format-wifi         = "{essid}  {signalStrength}%";
      };

      battery = {
        format          = "{icon} {capacity}%";
        format-charging = "󰂄 {capacity}%";
        format-plugged  = "󰂄 {capacity}%";

        format-icons = [
          "󰁺"
          "󰁻"
          "󰁼"
          "󰁽"
          "󰁾"
          "󰁿"
          "󰂀"
          "󰂁"
          "󰂂"
          "󰁹"
        ];

        states.warning  = 30;
        states.critical = 15;
      };

      clock = {
        tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
      };
    }];

    style = with upkgs.theme.withHashtag; ''
      * {
        border: none;
        border-radius: 0;
        font-family: "OpenSans";
      }

      #waybar {
        background: ${background};
        color: ${lightForeground};
      }

      #waybar:hover {
        border: 3px;
        border-color: ${base0A};
      }

      #workspace-1 {
        color: ${base08};
      }

      #workspace-2 {
        color: ${base09};
      }

      #workspace-3 {
        color: ${base0A};
      }

      #workspace-4 {
        color: ${base0B};
      }

      #workspace-5 {
        color: ${base0C};
      }
    '';
  };
}
