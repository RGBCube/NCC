{ pkgs, upkgs, ulib, systemConfiguration, homeConfiguration, homePackages, enabled, ... }: ulib.recursiveUpdate3

(systemConfiguration {
  hardware.opengl = enabled {};
})

(homeConfiguration "nixos" {
  wayland.windowManager.hyprland = enabled {
    package = upkgs.hyprland;

    extraConfig = let
      inherit (upkgs) theme;
    in
    ''
      monitor = , preferred, auto, 1
    ''
    +
    ''
      exec-once = wpaperd

      exec-once = wl-paste --type text  --watch cliphist store
      exec-once = wl-paste --type image --watch cliphist store
    ''
    +
    ''
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

      bindm = SUPER, mouse:272, movewindow
      bindm = SUPER, mouse:273, resizewindow
    ''
    +
    ''
      binde = SUPER, left,  movefocus, l
      binde = SUPER, up,    movefocus, u
      binde = SUPER, down,  movefocus, d
      binde = SUPER, right, movefocus, r

      binde = SUPER, h, movefocus, l
      binde = SUPER, k, movefocus, u
      binde = SUPER, j, movefocus, d
      binde = SUPER, l, movefocus, r
    ''
    +
    ''
      binde = SUPER+CTRL, left,  resizeactive, -10 0
      binde = SUPER+CTRL, up,    resizeactive, 0 -10
      binde = SUPER+CTRL, down,  resizeactive, 0 10
      binde = SUPER+CTRL, right, resizeactive, 10 0

      binde = SUPER+CTRL, h, resizeactive, -10 0
      binde = SUPER+CTRL, j, resizeactive, 0 10
      binde = SUPER+CTRL, k, resizeactive, 0 -10
      binde = SUPER+CTRL, l, resizeactive, 10 0
    ''
    +
    ''
      bind = SUPER+SHIFT, left,  movewindow, l
      bind = SUPER+SHIFT, up,    movewindow, u
      bind = SUPER+SHIFT, down,  movewindow, d
      bind = SUPER+SHIFT, right, movewindow, r

      bind = SUPER+SHIFT, h, movewindow, l
      bind = SUPER+SHIFT, j, movewindow, u
      bind = SUPER+SHIFT, k, movewindow, d
      bind = SUPER+SHIFT, l, movewindow, r
    ''
    +
    ''
      bind = SUPER,       Q, killactive
      bind = SUPER,       F, fullscreen
      bind = SUPER+SHIFT, F, togglefloating

      bind = SUPER, RETURN, exec, kitty
      bind = SUPER, W,      exec, firefox
      bind = SUPER, D,      exec, discord

      bind = SUPER, B, exec, pkill --signal SIGUSR1 waybar

      bind = SUPER, SPACE,  exec, pkill fuzzel; fuzzel
      bind = SUPER, V,      exec, pkill fuzzel; cliphist list | fuzzel --dmenu | cliphist decode | wl-copy

      bind =      , PRINT, exec, grim -g "$(slurp -w 0)" - | swappy -f - -o - | wl-copy --type image/png
      bind = SHIFT, PRINT, exec, grim                    - | swappy -f - -o - | wl-copy --type image/png
    ''
    +
    ''
      binde = , XF86AudioRaiseVolume, exec, wpctl set-volume --limit 1.5 @DEFAULT_AUDIO_SINK@ 5%+
      binde = , XF86AudioLowerVolume, exec, wpctl set-volume             @DEFAULT_AUDIO_SINK@ 5%-

      binde = , XF86AudioMute,    exec, wpctl set-mute @DEFAULT_AUDIO_SINK@   toggle
      binde = , XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle

      binde = , XF86MonBrightnessUp,   exec, brightnessctl set               5%+
      binde = , XF86MonBrightnessDown, exec, brightnessctl set --min-value=0 5%-
    ''
    +
    ''
      decoration {
        drop_shadow = false
        rounding    = 0

        blur {
          enabled = false
        }
      }
    ''
    +
    ''
      general {
        gaps_in     = 5
        gaps_out    = 10
        border_size = 2

        col.active_border         = 0x${theme.transparency}${theme.activeHighlight}
        col.nogroup_border_active = 0x${theme.transparency}${theme.activeHighlight}

        col.inactive_border = 0x${theme.transparency}${theme.inactiveHighlight}
        col.nogroup_border  = 0x${theme.transparency}${theme.inactiveHighlight}

        cursor_inactive_timeout = 10
        no_cursor_warps         = true

        resize_on_border = true
      }
    ''
    +
    ''
      gestures {
        workspace_swipe = true
      }
    ''
    +
    ''
      input {
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
    ''
    +
    ''
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
  cliphist
  grim
  slurp
  swappy
  wl-clipboard
  xdg-utils
  xwaylandvideobridge
])
