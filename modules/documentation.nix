{ ulib, ... }: with ulib;

systemConfiguration {
  documentation = {
    doc.enable  = false;
    info.enable = false;

    man = enabled {
      generateCaches = true;
    };
  };
}
