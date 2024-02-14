{ ulib, ... }: with ulib; merge

(systemConfiguration {
  console.keyMap = "trq";

  i18n.defaultLocale = "C.UTF-8";
})

(desktopSystemConfiguration {
  i18n.extraLocaleSettings = let
    locale = "tr_TR.UTF-8";
  in {
    LC_ADDRESS        = locale;
    LC_IDENTIFICATION = locale;
    LC_MEASUREMENT    = locale;
    LC_MONETARY       = locale;
    LC_NAME           = locale;
    LC_NUMERIC        = locale;
    LC_PAPER          = locale;
    LC_TELEPHONE      = locale;
    LC_TIME           = locale;
  };
})
