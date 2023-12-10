{ theme, homeConfiguration, enabled, ... }:

homeConfiguration "nixos" {
  programs.waybar = with theme.withHashtag; enabled {
    systemd = enabled {};

    settings = [{
      layer  = "top";
      height = 2 * corner-radius;

      margin-right = margin;
      margin-left  = margin;
      margin-top   = margin;

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

      tray = {
        reverse-direction = true;
        spacing           = 5;
      };

      pulseaudio = {
        format                 = "{format_source} {icon} {volume}%";
        format-bluetooth       = "{format_source} {icon} 󰂯 {volume}%";
        format-bluetooth-muted = "{format_source} 󰸈 {icon} 󰂯";
        format-muted           = "{format_source} 󰸈";
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
      memory.format = "󰽘 {}%";

      network = {
        format-disconnected = "󰤮 ";
        format-ethernet     = "󰈀 {ipaddr}/{cidr}";
        format-linked       = " {ifname} (No IP)";
        format-wifi         = " {signalStrength}%";
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

    style = ''
      * {
        border: none;
        border-radius: ${toString corner-radius}px;
        font-family: "${font.sans.name}";
      }

      .modules-right {
        margin-right: ${toString padding}px;
      }

      #waybar {
        background: ${base00};
        color: ${base05};
      }

      #workspaces button:nth-child(1) {
        color: ${base08};
      }

      #workspaces button:nth-child(2) {
        color: ${base09};
      }

      #workspaces button:nth-child(3) {
        color: ${base0A};
      }

      #workspaces button:nth-child(4) {
        color: ${base0B};
      }

      #workspaces button:nth-child(5) {
        color: ${base0C};
      }

      #tray, #pulseaudio, #backlight, #cpu, #memory, #network, #battery, #clock {
        margin-left: 20px;
      }
    '';
  };
}
