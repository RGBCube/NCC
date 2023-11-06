{ lib, pkgs, systemPackages, homeConfiguration, enabled, ... }: lib.recursiveUpdate

(with pkgs; systemPackages [
  bat
])

(homeConfiguration "nixos" {
  programs.nushell.environmentVariables = {
    PAGER    = "\"bat --plain\"";
    MANPAGER = "\"sh -c 'col --spaces --no-backspaces | bat --plain --language man'\"";
  };

  programs.bat = enabled {
    config.theme = "gruvbox-dark";
  };
})
