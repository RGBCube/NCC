{ ulib, pkgs, theme, ... }: with ulib;

homeConfiguration {
  programs.nushell.environmentVariables = {
    MANPAGER = ''"bat --plain --language man"'';
    PAGER    = ''"bat --plain"'';
  };

  programs.nushell.shellAliases = {
    cat  = "bat";
    less = "bat --plain";
  };

  programs.bat = enabled {
    config.theme  = "base16";
    themes.base16.src = pkgs.writeText "base16.tmTheme" theme.tmTheme;
  };
}
