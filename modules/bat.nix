{ config, lib, pkgs, ... }: with lib; merge

(systemConfiguration {
  environment.variables = {
    MANPAGER = "bat --plain";
    PAGER    = "bat --plain";
  };

  environment.shellAliases.cat  = "bat";
})

(homeConfiguration {
  programs.bat = enabled {
    config.theme      = "base16";
    themes.base16.src = pkgs.writeText "base16.tmTheme" config.theme.tmTheme;

    config.pager = "less -FR";
  };
})
