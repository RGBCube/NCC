{ lib, pkgs, hyprland, theme, systemConfiguration, homeConfiguration, homePackages, enabled, ... }: lib.recursiveUpdate3

(systemConfiguration {
  hardware.opengl = enabled {};
})

(homeConfiguration "nixos" {
  home.file.".config/hypr/volume.sh".source = ./volume.sh;

  wayland.windowManager.hyprland = enabled {
    package = hyprland;

    extraConfig = ''
      monitor = , preferred, auto, 1

      exec-once = wpaperd

      bind = SUPER, TAB, workspace, e+1

      bind = SUPER, 1, workspace, 1
      bind = SUPER, 2, workspace, 2
      bind = SUPER, 3, workspace, 3
      bind = SUPER, 4, workspace, 4
      bind = SUPER, 5, workspace, 5

      bind = SUPER+SHIFT, 1, movetoworkspacesilent, 1
      bind = SUPER+SHIFT, 2, movetoworkspacesilent, 2
      bind = SUPER+SHIFT, 3, movetoworkspacesilent, 3
      bind = SUPER+SHIFT, 4, movetoworkspacesilent, 4
      bind = SUPER+SHIFT, 5, movetoworkspacesilent, 5

      bind = SUPER+CTRL, 1, movewindow, mon:1
      bind = SUPER+CTRL, 2, movewindow, mon:2
      bind = SUPER+CTRL, 3, movewindow, mon:3
      bind = SUPER+CTRL, 4, movewindow, mon:4
      bind = SUPER+CTRL, 5, movewindow, mon:5

      ##################################################

      bindm = SUPER, mouse:272, movewindow
      bindm = SUPER, mouse:273, resizewindow

      ##################################################

      bind   = SUPER, A, submap, fastedit
      submap =                   fastedit

      binde = , left,  movefocus, l
      binde = , right, movefocus, t
      binde = , up,    movefocus, u
      binde = , down,  movefocus, d

      binde = CTRL, right, resizeactive,  10   0
      binde = CTRL, left,  resizeactive, -10   0
      binde = CTRL, up,    resizeactive,   0 -10
      binde = CTRL, down,  resizeactive,   0  10

      bind = SHIFT, left,  movewindow, l
      bind = SHIFT, right, movewindow, r
      bind = SHIFT, up,    movewindow, u
      bind = SHIFT, down,  movewindow, d

      bind   = , escape, submap, reset
      submap =                   reset

      ##################################################

      bind = SUPER,       Q, killactive
      bind = SUPER,       F, fullscreen
      bind = SUPER+SHIFT, F, togglefloating

      bind = SUPER, SPACE,  exec, fuzzel
      bind = SUPER, RETURN, exec, kitty
      bind = SUPER, W,      exec, firefox
      bind = SUPER, D,      exec, discord

      bind =      , PRINT, exec, grim -g "$(slurp)" - | wl-copy --type image/png
      bind = SHIFT, PRINT, exec, grim               - | wl-copy --type image/png
      bind = CTRL,  PRINT, exec, kazam

      binde = , XF86AudioRaiseVolume, exec, wpctl set-volume --limit 1.5 @DEFAULT_AUDIO_SINK@ 5%+; /home/nixos/.config/hypr/volume.sh
      binde = , XF86AudioLowerVolume, exec, wpctl set-volume             @DEFAULT_AUDIO_SINK@ 5%-; /home/nixos/.config/hypr/volume.sh

      binde = , XF86AudioMute,    exec, wpctl set-sink-mute   @DEFAULT_AUDIO_SINK@ toggle; dunstctl close-all; dunstify --timeout 1000 Speakers "Mute Status Toggled"
      binde = , XF86AudioMicMute, exec, wpctl set-source-mute @DEFAULT_AUDIO_SINK@ toggle; dunstctl close-all; dunstify --timeout Microphones "Mute Status Toggled"

      binde = , XF86MonBrightnessUp,   exec, brightnessctl set               5%+; dunstctl close-all; dunstify --timeout 1000 $(brightnessctl -m | cut -d, -f4)
      binde = , XF86MonBrightnessDown, exec, brightnessctl set --min-value=0 5%-; dunstctl close-all; dunstify --timeout 1000 $(brightnessctl -m | cut -d, -f4)

      decoration {
        drop_shadow = false
        rounding    = 0

        blur {
          enabled = false
        }
      }

      general {
        gaps_in     = 5
        gaps_out    = 10
        border_size = 2

        col.active_border         = 0x${theme.transparency}${theme.activeHighlight}
        col.nogroup_border_active = 0x${theme.transparency}${theme.activeHighlight}

        col.inactive_border = 0x${theme.transparency}${theme.inactiveHighlight}
        col.nogroup_border  = 0x${theme.transparency}${theme.inactiveHighlight}

        no_cursor_warps = true

        resize_on_border = true
      }

      input {
        # The window under the mouse will always be in focus.
        follow_mouse = 1

        kb_layout = tr

        repeat_delay = 400
        repeat_rate  = 60

        touchpad {
          drag_lock = true

          natural_scroll = true
          scroll_factor  = 0.8
        }
      }

      misc {
        animate_manual_resizes       = true
        animate_mouse_windowdragging = true

        disable_hyprland_logo    = true
        disable_splash_rendering = true

        key_press_enables_dpms  = true
        mouse_move_enables_dpms = true
      }
    '';
  };

  programs.wpaperd = enabled {
    settings.default = {
      duration = "10m";
      path     = "/home/nixos/Pictures/Wallpapers";
      sorting  = "ascending";
    };
  };
})

(with pkgs; homePackages "nixos" [
  brightnessctl
  grim
  slurp
  wl-clipboard
])
