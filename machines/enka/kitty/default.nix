{ pkgs, homeConfiguration, enabled, ... }:

homeConfiguration "nixos" {
  programs.kitty = enabled {
    font.name = "JetBrainsMono Nerd Font";
    font.size = 16;
    theme     = "Gruvbox Dark";

    settings = {
      scrollback_lines = 100000;
      mouse_hide_wait  = 0;
    }
  };
}
