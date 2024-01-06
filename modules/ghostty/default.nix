{ inputs, lib, ulib, pkgs, upkgs, theme, ... }: with ulib; merge

(desktopSystemConfiguration {
  home-manager.sharedModules = [ inputs.ghosttyModule.homeModules.default ];
})

(desktopHomeConfiguration {
  programs.nushell.environmentVariables.TERMINAL = "ghostty";

  programs.ghostty = enabled {
    package = upkgs.ghostty;

    clearDefaultKeybindings = true;

    keybindings = (lib.mapAttrs' (name: value: lib.nameValuePair "ctrl+shift+${name}" value) {
      c = "copy_to_clipboard";
      v = "paste_from_clipboard";

      z = "jump_to_prompt:-2";
      x = "jump_to_prompt:2";

      h = "write_scrollback_file";
      i = "inspector:toggle";

      page_down = "scroll_page_fractional:0.33";
      down      = "scroll_page_lines:1";
      j         = "scroll_page_lines:1";

      page_up = "scroll_page_fractional:-0.33";
      up      = "scroll_page_lines:-1";
      k       = "scroll_page_lines:-1";

      home = "scroll_to_top";
      end  = "scroll_to_bottom";

      "physical:kp_enter"    = "reset_font_size";
      "physical:kp_add"      = "increase_font_size:1";
      "physical:kp_subtract" = "decrease_font_size:1";

      t = "new_tab";
      q = "close_surface";

      "physical:one"   = "goto_tab:1";
      "physical:two"   = "goto_tab:2";
      "physical:three" = "goto_tab:3";
      "physical:four"  = "goto_tab:4";
      "physical:five"  = "goto_tab:5";
      "physical:six"   = "goto_tab:6";
      "physical:seven" = "goto_tab:7";
      "physical:eight" = "goto_tab:8";
      "physical:nine"  = "goto_tab:9";
      "physical:zero"  = "goto_tab:10";
    }) // (lib.mapAttrs' (name: value: lib.nameValuePair "ctrl+${name}" value) {
      "physical:tab"         = "next_tab";
      "shift+physical:tab" = "previous_tab";
    });

    shellIntegration.enable = false;

    settings = with theme; {
      font-size   = font.size.normal;
      font-family = font.mono.name;

      window-padding-x = padding;
      window-padding-y = padding;

      confirm-close-surface = false;
      gtk-single-instance   = true;

      window-decoration = false;

      config-file = [
        (toString (pkgs.writeText "base16-config" ghosttyConfig))
      ];
    };
  };
})
