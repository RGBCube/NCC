{ ulib, ... }: with ulib;

systemConfiguration {
  security.sudo = enabled {
    extraConfig   = ''
      Defaults timestamp_timeout=${if ulib.isDesktop then "-1" else "0"}
    '';
    execWheelOnly = true;
  };
}
