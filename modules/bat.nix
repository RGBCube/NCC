{ config, lib, pkgs, ... }: with lib; merge

(let
  batPlain = pkgs.writeScript "bat-plain" ''
    bat --plain $@
  '';
in systemConfiguration {
  environment.variables = {
    MANPAGER = toString batPlain;
    PAGER    = toString batPlain;
  };

  environment.shellAliases = {
    cat  = "bat";
    less = toString batPlain;
  };
})

(homeConfiguration {
  programs.bat = enabled {
    config.theme      = "base16";
    themes.base16.src = pkgs.writeText "base16.tmTheme" config.theme.tmTheme;

    config.pager = "less -FR";
  };
})
