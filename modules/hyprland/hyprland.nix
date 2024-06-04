{ config, lib, pkgs, hyprland, ... }: with lib; merge

(let
  hyprPkgs = import hyprland.inputs.nixpkgs { inherit (config.nixpkgs.hostPlatform) system; };
in desktopSystemConfiguration {
  hardware.opengl = enabled {
    package   = hyprPkgs.mesa.drivers;
    package32 = hyprPkgs.pkgsi686Linux.mesa.drivers;
  };

  services.logind.powerKey = "ignore";

  xdg.portal = enabled {
    config.common.default = "*";

    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
    ];
  };

  programs.xwayland = enabled;
})

(desktopUserHomeConfiguration {
  xdg.configFile."xkb/symbols/tr-swapped-i".text = ''
    default partial
    xkb_symbols "basic" {
      include "tr(basic)"

      name[Group1]="Turkish (i and ı swapped)";

      key <AC11>  { type[group1] = "FOUR_LEVEL_SEMIALPHABETIC", [ idotless, Iabovedot,  paragraph , none      ]};
      key <AD08>  { type[group1] = "FOUR_LEVEL_SEMIALPHABETIC", [ i       , I        ,  apostrophe, dead_caron ]};
    };
  '';

  wayland.windowManager.hyprland = enabled {
    systemd = enabled {
      enableXdgAutostart = true;
    };

    settings = {
      monitor = [ ", preferred, auto, 1" ];

      windowrule   = [ "noinitialfocus" ];
      windowrulev2 = [ "workspace special silent, initialclass:^(xwaylandvideobridge)$" ];

      exec = [ "pkill swaybg; swaybg --image ${./wallpaper.png}" ];

      bindle = [
        ", XF86AudioRaiseVolume , exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ --limit 1.5"
        ", XF86AudioLowerVolume , exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"

        ", XF86MonBrightnessUp  , exec, brightnessctl set 5%+"
        ", XF86MonBrightnessDown, exec, brightnessctl set --min-value=0 5%-"
      ];

      bindl = [
        ", XF86AudioMute        , exec, wpctl set-mute @DEFAULT_AUDIO_SINK@   toggle"
        ", XF86AudioMicMute     , exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
      ];

      bindm = [
        "SUPER, mouse:272, movewindow"
        "SUPER, mouse:274, movewindow"
        "SUPER, mouse:273, resizewindow"
      ];

      binde = [
        "SUPER, left , movefocus, l"
        "SUPER, down , movefocus, d"
        "SUPER, up   , movefocus, u"
        "SUPER, right, movefocus, r"

        "SUPER, h, movefocus, l"
        "SUPER, j, movefocus, d"
        "SUPER, k, movefocus, u"
        "SUPER, l, movefocus, r"

        "SUPER+CTRL, left , resizeactive, -100 0"
        "SUPER+CTRL, down , resizeactive, 0 100"
        "SUPER+CTRL, up   , resizeactive, 0 -100"
        "SUPER+CTRL, right, resizeactive, 100 0"

        "SUPER+CTRL, h, resizeactive, -100 0"
        "SUPER+CTRL, j, resizeactive, 0 100"
        "SUPER+CTRL, k, resizeactive, 0 -100"
        "SUPER+CTRL, l, resizeactive, 100 0"
      ];

      bind = flatten [
        "SUPER    , TAB, workspace, e+1"
        "SUPER+ALT, TAB, workspace, e-1"

        "SUPER, mouse_up,   workspace, e+1"
        "SUPER, mouse_down, workspace, e-1"

        (map (n: [
          "SUPER    , ${toString n}, workspace            , ${toString n}"
          "SUPER+ALT, ${toString n}, movetoworkspacesilent, ${toString n}"
        ]) (range 1 9))
        "SUPER    , 0, workspace            , 10"
        "SUPER+ALT, 0, movetoworkspacesilent, 10"

        "SUPER+ALT, left , movewindow, l"
        "SUPER+ALT, down , movewindow, d"
        "SUPER+ALT, up   , movewindow, u"
        "SUPER+ALT, right, movewindow, r"

        "SUPER+ALT, h, movewindow, l"
        "SUPER+ALT, j, movewindow, d"
        "SUPER+ALT, k, movewindow, u"
        "SUPER+ALT, l, movewindow, r"
        
        "SUPER    , Q, killactive"
        "SUPER    , F, fullscreen"
        "SUPER+ALT, F, togglefloating"

        "SUPER+ALT, RETURN, exec, kitty"
        "SUPER    , RETURN, exec, ghostty --gtk-single-instance=true"
        "SUPER    , W     , exec, firefox"
        "SUPER    , D     , exec, discord"
        "SUPER    , M     , exec, thunderbird"
        "SUPER    , T     , exec, thunar"
        "SUPER    , C     , exec, hyprpicker --autocopy"

        "   , PRINT, exec, pkill grim; grim -g \"$(slurp -w 0)\" - | swappy -f - -o - | wl-copy --type image/png"
        "ALT, PRINT, exec, pkill grim; grim                      - | swappy -f - -o - | wl-copy --type image/png"
      ];

      general = with config.theme; {
        gaps_in     = margin / 2;
        gaps_out    = margin;
        border_size = borderWidth;

        "col.active_border"         = "0xFF${base0A}";
        "col.nogroup_border_active" = "0xFF${base0A}";

        "col.inactive_border" = "0xFF${base01}";
        "col.nogroup_border"  = "0xFF${base01}";

        resize_on_border = true;
      };

      decoration = {
        drop_shadow = false;
        rounding    = config.theme.cornerRadius;

        blur.enabled = false;
      };

      input = {
        follow_mouse = 1;

        kb_layout = "tr-swapped-i";

        repeat_delay = 400;
        repeat_rate  = 100;

        touchpad = {
          clickfinger_behavior = true;
          drag_lock            = true;

          natural_scroll = true;
          scroll_factor  = 0.7;
        };
      };

      gestures.workspace_swipe = true;

      animations = {
        bezier = [ "material_decelerate, 0.05, 0.7, 0.1, 1" ];

        animation = [
          "border    , 1, 10, material_decelerate"
          "fade      , 1, 2 , material_decelerate"
          "layers    , 1, 2 , material_decelerate"
          "windows   , 1, 2 , material_decelerate, popin 80%"
          "workspaces, 1, 3 , material_decelerate"
        ];
      };

      misc = {
        animate_manual_resizes = true;

        background_color         = config.theme.with0x.base00;
        disable_hyprland_logo    = true;
        disable_splash_rendering = true;

        key_press_enables_dpms   = true;
        mouse_move_enables_dpms  = true;
      };

      cursor = {
        hide_on_key_press = true;
        inactive_timeout  = 10;
        no_warps          = true;
      };

      dwindle = {
        preserve_split = true;
        smart_resizing = false;
      };
    };
  };
})

(desktopUserHomePackages (with pkgs; [
  brightnessctl
  grim
  hyprpicker
  slurp
  swappy
  swaybg
  wl-clipboard
  wtype
  xdg-utils
  xwaylandvideobridge
]))
