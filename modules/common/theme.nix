{ lib, pkgs, themes, ... }: let
  inherit (lib) mkValue;
in {
  options.theme = mkValue <| themes.custom <| themes.raw.gruvbox-dark-hard // {
    cornerRadius = 4;
    borderWidth  = 2;

    margin  = 0;
    padding = 8;

    font.size.normal = 16;
    font.size.big    = 20;

    font.sans.name    = "Lexend";
    font.sans.package = pkgs.lexend;

    font.mono.name    = "JetBrainsMono Nerd Font";
    font.mono.package = pkgs.nerd-fonts.jetbrains-mono;

    icons.name    = "Gruvbox-Plus-Dark";
    icons.package = pkgs.gruvbox-plus-icons;
  };
}

