{ pkgs, upkgs, theme, homeConfiguration, enabled, ghosttyModule, ... }:

homeConfiguration "nixos" {
  imports = [ ghosttyModule.homeModules.default ];

  programs.ghostty = enabled {
    package = upkgs.ghostty;

    shellIntegration.enable = false;

    settings = with theme.font; {
      font-size   = size.normal;
      font-family = mono.name;

      config-file = [
        (toString (pkgs.writeText "base16-config" theme.ghosttyConfig))
      ];
    };
  };
}
