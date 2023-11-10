{ lib, pkgs, systemPackages, homeConfiguration, enabled, ... }: lib.recursiveUpdate

(with pkgs; systemPackages [
  bat
])

(homeConfiguration "nixos" {
  programs.nushell.environmentVariables = {
    MANPAGER = "bat --plain --language man";
    PAGER    = "bat --plain";
  };

  programs.bat = enabled {
    config.theme = "gruvbox-dark";
  };
})
