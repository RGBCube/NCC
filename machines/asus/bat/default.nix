{ lib, pkgs, systemPackages, homeConfiguration, enabled, ... }: lib.recursiveUpdate

(with pkgs; systemPackages [
  bat
])

(homeConfiguration "nixos" {
  programs.nushell.environmentVariables = {
    PAGER = "\"bat --plain\"";
    MANPAGER = "\"sh -c 'col --spaces --no-backspaces | bat --plain --language man'\"";
  };

  programs.bat = enabled {
    config.theme = "catppuccin";

    themes.catppuccin = builtins.readFile (pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "bat";
      rev = "ba4d16880d63e656acced2b7d4e034e4a93f74b1";
      sha256 = "sha256-6WVKQErGdaqb++oaXnY3i6/GuH2FhTgK0v4TN4Y0Wbw=";
    } + "/Catppuccin-mocha.tmTheme");
  };
})
