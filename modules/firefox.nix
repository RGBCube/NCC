{ ulib, theme, ... }: with ulib;

desktopHomeConfiguration {
  programs.firefox = enabled {
    profiles.default.settings = with theme.font; {
      "general.autoScroll"               = true;
      "privacy.donottrackheader.enabled" = true;

      "browser.fixup.domainsuffixwhitelist.idk" = true;

      "font.name.serif.x-western"    = sans.name;
      "font.size.variable.x-western" = builtins.ceil (1.3 * size.normal);
    };
  };
}
