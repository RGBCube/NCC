{ pkgs, upkgs, ulib, systemConfiguration, homeConfiguration, homePackages, enabled, ... }: ulib.recursiveUpdate3

(systemConfiguration {
  hardware.opengl = enabled {};
})

(homeConfiguration "nixos" {
  wayland.windowManager.hyprland = enabled {
    package = upkgs.hyprland;

    extraConfig =
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
      binde = SUPER, left,  movefocus, l
      binde = SUPER, down,  movefocus, d
      binde = SUPER, up,    movefocus, u
      binde = SUPER, right, movefocus, r

      binde = SUPER, h, movefocus, l
      binde = SUPER, j, movefocus, d
      binde = SUPER, k, movefocus, u
      binde = SUPER, l, movefocus, r
    ''
    +
    ''
      bind = SUPER, TAB, workspace, e+1

      bind = SUPER, 1, workspace, 1
      bind = SUPER, 2, workspace, 2
      bind = SUPER, 3, workspace, 3
      bind = SUPER, 4, workspace, 4
      bind = SUPER, 5, workspace, 5

      bind = SUPER+ALT, 1, movetoworkspacesilent, 1
      bind = SUPER+ALT, 2, movetoworkspacesilent, 2
      bind = SUPER+ALT, 3, movetoworkspacesilent, 3
      bind = SUPER+ALT, 4, movetoworkspacesilent, 4
      bind = SUPER+ALT, 5, movetoworkspacesilent, 5

      bindm = SUPER, mouse:272, movewindow
    ''
    +
    ''
      binde = SUPER+CTRL, left,  resizeactive, -10 0
      binde = SUPER+CTRL, down,  resizeactive, 0 10
      binde = SUPER+CTRL, up,    resizeactive, 0 -10
      binde = SUPER+CTRL, right, resizeactive, 10 0

      binde = SUPER+CTRL, h, resizeactive, -10 0
      binde = SUPER+CTRL, j, resizeactive, 0 10
      binde = SUPER+CTRL, k, resizeactive, 0 -10
      binde = SUPER+CTRL, l, resizeactive, 10 0

      bindm = SUPER, mouse:273, resizewindow
    ''
    +
    ''
      bind = SUPER+ALT, left,  movewindow, l
      bind = SUPER+ALT, down,  movewindow, d
      bind = SUPER+ALT, up,    movewindow, u
      bind = SUPER+ALT, right, movewindow, r

      bind = SUPER+ALT, h, movewindow, l
      bind = SUPER+ALT, j, movewindow, d
      bind = SUPER+ALT, k, movewindow, u
      bind = SUPER+ALT, l, movewindow, r
    ''
    +
    ''
      bind = SUPER,       Q, killactive
      bind = SUPER,       F, fullscreen
      bind = SUPER+ALT, F, togglefloating

      bind = SUPER, RETURN, exec, kitty
      bind = SUPER, W,      exec, firefox
      bind = SUPER, D,      exec, discord

      bind = SUPER, B, exec, pkill --signal SIGUSR1 waybar

      bind = SUPER, SPACE,  exec, pkill fuzzel; fuzzel
      bind = SUPER, V,      exec, pkill fuzzel; cliphist list | fuzzel --dmenu | cliphist decode | wl-copy

      bind =    , PRINT, exec, grim -g "$(slurp -w 0)" - | swappy -f - -o - | wl-copy --type image/png
      bind = ALT, PRINT, exec, grim                    - | swappy -f - -o - | wl-copy --type image/png
    ''
    +
    ''
      binde = , XF86AudioRaiseVolume, exec, wpctl set-volume --limit 1.5 @DEFAULT_AUDIO_SINK@ 5%+
      binde = , XF86AudioLowerVolume, exec, wpctl set-volume             @DEFAULT_AUDIO_SINK@ 5%-

      binde = , XF86AudioMute,    exec, wpctl set-mute @DEFAULT_AUDIO_SINK@   toggle
      binde = , XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle

      bindle = , XF86MonBrightnessUp,   exec, brightnessctl set               5%+
      bindle = , XF86MonBrightnessDown, exec, brightnessctl set --min-value=0 5%-

      bindle = , XF86PowerOff, exec, pkill fuzzel; echo -e "Suspend\nHibernate\nPower Off\nReboot" | fuzzel --dmenu | tr --delete " " | tr "[:upper:]" "[:lower:]" | xargs systemctl
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
    (with upkgs.theme; ''
      general {
        max_fps = 60

        gaps_in     = 5
        gaps_out    = 10
        border_size = 3

        col.active_border         = 0xFF${base0A}
        col.nogroup_border_active = 0xFF${base0A}

        col.inactive_border = 0xFF${base01}
        col.nogroup_border  = 0xFF${base01}

        cursor_inactive_timeout = 10
        no_cursor_warps         = true

        resize_on_border = true
      }
    '')
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
          scroll_factor  = 0.7
        }
      }
    ''
    +
    ''
      dwindle {
        no_gaps_when_only = 0
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
