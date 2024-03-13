{ ulib, theme, ... }: with ulib;

desktopHomeConfiguration {
  programs.librewolf = enabled {
    settings = with theme.font; {
      "general.autoScroll"               = true;
      "identity.fxaccounts.enabled"      = true;
      "privacy.clearOnShutdown.history"  = false;
      "privacy.resistFingerprinting"     = false;
      "privacy.donottrackheader.enabled" = true;
      "webgl.disabled"                   = false;

      "browser.fixup.domainsuffixwhitelist.idk" = true;

      "font.name.serif.x-western"    = sans.name;
      "font.size.variable.x-western" = builtins.ceil (1.3 * size.normal);
    };
  };
}
