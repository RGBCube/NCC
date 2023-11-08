{ pkgs, homeConfiguration, enabled, ... }:

homeConfiguration "nixos" {
  programs.kitty = enabled {
    font.name    = "JetBrainsMono Nerd Font";
    font.package = (pkgs.nerdfonts.override {
      fonts = [
        "JetBrainsMono"
      ];
    });
    font.size = 12;
    theme     = "Gruvbox Dark";

    settings = {
      scrollback_lines = 100000;
      mouse_hide_wait  = 0;
    };
  };
}
