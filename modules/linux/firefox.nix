{ config, lib, ... }: let
  inherit (lib) enabled merge mkIf;
in merge <| mkIf config.isDesktop {
  home-manager.sharedModules = [{
    programs.firefox = enabled {
      profiles.default = {
        settings = with config.theme.font; {
          "general.autoScroll"               = true;
          "privacy.donottrackheader.enabled" = true;

          "browser.fixup.domainsuffixwhitelist.idk" = true;

          "font.name.serif.x-western"    = sans.name;
          "font.size.variable.x-western" = builtins.ceil (1.3 * size.normal);

          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        };

        userChrome = ''
          #TabsToolbar {
            visibility: collapse;
          }
        '';
      };
    };
  }];
}

