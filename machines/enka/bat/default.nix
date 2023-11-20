{ homeConfiguration, enabled, ... }:

homeConfiguration [ "nixos" "root" ] {
  programs.nushell.environmentVariables = {
    MANPAGER = ''"bat --plain --language man"'';
    PAGER    = ''"bat --plain"'';
  };

  programs.nushell.shellAliases = {
    cat  = "bat";
    less = "bat --plain";
  };

  programs.bat = enabled {
    config.theme = "gruvbox-dark";
  };
}
