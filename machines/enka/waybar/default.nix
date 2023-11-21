{ homeConfiguration, enabled, ... }:

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
      };

      modules-center = [
        "hyprland/window"
      ];

      "hyprland/window".seperate-outputs = true;

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
        format                 = "{volume}% {icon} {format_source}";
        format-bluetooth       = "{volume}% {icon}󰂯 {format_source}";
        format-bluetooth-muted = "󰝟 {icon}󰂯 {format_source}";
        format-muted           = "󰝟 {format_source}";
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
        format       = "{percent}% {icon}";
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

      cpu.format    = "{usage}% 󰻠";
      memory.format = "{}% 󰍛";

      network = {
        format-alt          = "{ifname}: {ipaddr}/{cidr}";
        format-disconnected = "󰤮";
        format-ethernet     = "{ipaddr}/{cidr} 󰈀";
        format-linked       = "{ifname} (No IP) ";
        format-wifi         = "{essid} ({signalStrength}%) ";
      };

      battery = {
        format          = "{capacity}% {icon}";
        format-charging = "{capacity}% 󰂄";
        format-plugged  = "{capacity}% 󰂄";

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
  };
}
