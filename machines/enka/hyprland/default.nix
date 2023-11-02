{ homeConfiguration, enabled, ... }:

homeConfiguration "nixos" {
  wayland.windowManager.hyprland = enabled {
    extraConfig = ''
      monitor = , preferred, auto, 1

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

      ##################################################

      bind = SUPER, mouse:272, movewindow
      bind = SUPER, mouse:273, resizewindow

      ##################################################

      bind   = SUPER, A, submap, fastedit
      submap =                   fastedit

      bind = , left,  movefocus, l
      bind = , right, movefocus, t
      bind = , up,    movefocus, u
      bind = , down,  movefocus, d

      bind = CTRL, right, resizeactive, 10 0
      bind = CTRL, left,  resizeactive, -10 0
      bind = CTRL, up,    resizeactive, 0 -10
      bind = CTRL, down,  resizeactive, 0 10

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

      bind = SUPER,  , exec, fuzzel
      bind = SUPER, T, exec, kitty
      bind = SUPER, W, exec, firefox
      bind = SUPER, D, exec, discord

      bind =      , Print, exec, grim -g "$(slurp)" - | wl-copy
      bind = SHIFT, Print, exec, kazam

      general {
        gaps_in  = 5
        gaps_out = 5

        $active_color   = 0xD79921
        $inactive_color = 0x928374

        col.active_border         = $active_color
        col.nogroup_border_active = $active_color

        col.inactive_border = $inactive_color
        col.nogroup_border  = $inactive_color

        no_focus_fallback = true
        no_cursor_warps = true

        resize_on_border = true
      }

      decoration {
        rounding    = 0
        drop_shadow = false

        blur {
          enabled = false
        }
      }

      input {
        kb_layout = tr

        repeat_delay = 400
        repeat_rate  = 60

        # The window under the mouse will always be in focus.
        follow_mouse = 1
      }

      misc {
        disable_hyprland_logo    = true
        disable_splash_rendering = true

        mouse_move_enables_dpms = true
        key_press_enables_dpms  = true

        animate_manual_resizes       = true
        animate_mouse_windowdragging = true

        disable_autoreload = true
      }
    '';
  };
}

