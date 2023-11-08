{ lib, pkgs, systemPackages, homeConfiguration, enabled, ... }: lib.recursiveUpdate

(with pkgs; systemPackages [
  bat
])

(homeConfiguration "nixos" {
  programs.nushell.environmentVariables = {
    MANPAGER = "sh -c 'bat --plain --language man'";
    PAGER    = "sh -c 'bat --plain'";
  };

  programs.bat = enabled {
    config.theme = "gruvbox-dark";
  };
})
