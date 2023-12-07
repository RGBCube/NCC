{ pkgs, upkgs, theme, homeConfiguration, enabled, ... }:

homeConfiguration "nixos" {
  programs.nushell.environmentVariables.TERMINAL = "ghostty";

  programs.ghostty = enabled {
    package = upkgs.ghostty;

    shellIntegration.enable = false;

    settings = with theme; {
      font-size   = font.size.normal;
      font-family = font.mono.name;

      window-padding-x = padding;
      window-padding-y = padding;

      confirm-close-surface = false;

      window-decoration = false;

      config-file = [
        (toString (pkgs.writeText "base16-config" ghosttyConfig))
      ];
    };
  };
}
