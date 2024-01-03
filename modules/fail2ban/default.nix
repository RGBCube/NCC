{ ulib, ... }: with ulib;

serverSystemConfiguration {
  services.fail2ban = enabled {
    bantime           = "24h";
    bantime-increment = enabled {
      maxtime = "7d";
    };
  };
}
