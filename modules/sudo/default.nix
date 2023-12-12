{ ulib, ... }: with ulib;

systemConfiguration {
  security.sudo = enabled {
    extraConfig   = ''
      Defaults timestamp_timeout=-1
    '';
    execWheelOnly = true;
  };
}
