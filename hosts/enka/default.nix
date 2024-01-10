{ config, ulib, ... }: with ulib; merge

(systemConfiguration {
  system.stateVersion = "23.05";

  nixpkgs.hostPlatform = "x86_64-linux";

  time.timeZone = "Europe/Istanbul";

  users.users.root.passwordFile = config.age.secrets."enka.said.password".path;

  users.users.said = graphicalUser {
    description = "Said";
    extraGroups = [ "wheel" ];
    passwordFile = config.age.secrets."enka.said.password".path;
    uid         = 1000;
  };

  users.users.orhan = graphicalUser {
    description = "Orhan";
    passwordFile = builtins.trace (config.age.secrets) config.age.secrets."enka.orhan.password".path;
    uid         = 1001;
  };

  networking.firewall = enabled {
    allowedTCPPorts = [ 8080 ];
  };
})

(homeConfiguration {
  home.stateVersion = "23.05";
})
