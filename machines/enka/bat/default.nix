{ lib, pkgs, systemPackages, homeConfiguration, enabled, ... }: lib.recursiveUpdate

(with pkgs; systemPackages [
  bat
])

(homeConfiguration "nixos" {
  programs.nushell.environmentVariables = {
    MANPAGER = ''"sh -c 'col --spaces --no-backspaces | bat --plain --language man'"'';
    PAGER    = "'bat --plain'";
  };

  programs.nushell.shellAliases = {
    "'git diff'" = "sh -c 'git diff --name-only --relative --diff-filter=d | xargs bat --diff'";
  };

  programs.bat = enabled {
    config.theme = "gruvbox-dark";
  };
})
