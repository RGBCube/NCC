{ pkgs, systemConfiguration, systemPackages, ... }:

(with pkgs; systemPackages [
  bat
])

//

(systemConfiguration {
  environment.variables = {
    PAGER = "bat --plain";
    MANPAGER = "col --spaces --no-backspaces | bat --plain --language man";
  };
})
