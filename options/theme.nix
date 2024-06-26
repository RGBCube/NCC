{ lib, pkgs, themes, ... }: {
  options.theme = lib.mkValue (themes.custom (themes.raw.gruvbox-dark-hard // {
    cornerRadius = 8;
    borderWidth  = 2;

    margin  = 8;
    padding = 8;

    font.size.normal = 16;
    font.size.big    = 20;

    font.sans.name    = "Lexend";
    font.sans.package = pkgs.lexend;

    font.mono.name    = "JetBrainsMono Nerd Font";
    font.mono.package = (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; });

    icons.name    = "Gruvbox-Plus-Dark";
    icons.package = pkgs.gruvbox-plus-icons;
  }));
}
