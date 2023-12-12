{ lib, ulib, pkgs, upkgs, theme, ... }: with ulib;

graphicalConfiguration {
  programs.nushell.environmentVariables.TERMINAL = "ghostty";

  programs.ghostty = enabled {
    package = upkgs.ghostty;

    clearDefaultKeybindings = true;

    keybindings = (lib.mapAttrs' (name: value: lib.nameValuePair "ctrl+shift+${name}" value) {
      c = "copy_to_clipboard";
      v = "paste_from_clipboard";

      # z = "scroll_to_prompt:-1";
      # x = "scroll_to_prompt:1";

      down = "scroll_page_lines:1";
      j    = "scroll_page_lines:1";

      up = "scroll_page_lines:-1";
      k  = "scroll_page_lines:-1";

      home = "scroll_to_top";
      end  = "scroll_to_bottom";

      # plus  = "increase_font_size:2";
      minus = "decrease_font_size:2";

      t = "new_tab";
      q = "close_surface";

      # "1" = "goto_tab:1";
      # "2" = "goto_tab:2";
      # "3" = "goto_tab:3";
      # "4" = "goto_tab:4";
      # "5" = "goto_tab:5";
      # "6" = "goto_tab:6";
      # "7" = "goto_tab:7";
      # "8" = "goto_tab:8";
      # "9" = "goto_tab:9";
      # "0" = "goto_tab:10";
    }) // (lib.mapAttrs' (name: value: lib.nameValuePair "ctrl+${name}" value) {
      tab = "next_tab";
      "shift+tab" = "previous_tab";
    });

    shellIntegration.enable = false;

    settings = with theme; {
      font-size   = font.size.normal;
      font-family = font.mono.name;

      window-padding-x = padding;
      window-padding-y = padding;

      confirm-close-surface = false;

      window-decoration = false;

      config-file = [
        (toString (pkgs.writeText "base16-config" ghosttyConfig))
      ];
    };
  };
}
