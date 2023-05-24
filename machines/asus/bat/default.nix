{ lib, pkgs, systemConfiguration, systemPackages, ... }: lib.recursiveUpdate

(with pkgs; systemPackages [
  bat
])

(systemConfiguration {
  environment.sessionVariables = {
    PAGER = "bat --plain";
    MANPAGER = "sh -c 'col --spaces --no-backspaces | bat --plain --language man'";
  };
})
