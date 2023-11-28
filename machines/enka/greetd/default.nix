{ pkgs, upkgs, systemConfiguration, enabled, ... }:

let
  hyprlandBin = "${upkgs.hyprland}/bin";

  hyprlandConfig = pkgs.writeText "hyprland.conf" ''
    misc {
      force_default_wallpaper = 0
    }

    animations {
      enabled                = 0
      first_launch_animation = 0
    }

    workspace = 1, default: true, gapsout: 0, gapsin: 0, border: false, decorate: false

    exec-once = systemctl --user stop waybar.service

    exec-once = [workspace 1; fullscreen; noanim] ${pkgs.greetd.gtkgreet}/bin/gtkgreet --layer-shell --command Hyprland; ${hyprlandBin}}/bin/hyprctl dispatch exit

    exec-once = ${hyprlandBin}/bin/hyprctl dispatch focuswindow gtkgreet
  '';
in systemConfiguration {
  services.greetd = enabled {
    settings.default_session = {
      command = "${hyprlandBin}/Hyprland --config ${hyprlandConfig}";
      user    = "nixos";
    };
  };

  environment.etc."greetd/environments".text = ''
    Hyprland
  '';
}
