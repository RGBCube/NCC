{ config, ulib, ... }: with ulib; merge

(systemConfiguration {
  system.stateVersion  = "23.05";
  nixpkgs.hostPlatform = "x86_64-linux";

  time.timeZone = "Europe/Istanbul";

  age.secrets."hosts/enka/password.said".file  = ./password.said.age;
  age.secrets."hosts/enka/password.orhan".file = ./password.orhan.age;

  users.users.root.hashedPasswordFile = config.age.secrets."hosts/enka/password.said".path;

  users.users.said = graphicalUser {
    description        = "Said";
    extraGroups        = [ "wheel" ];
    hashedPasswordFile = config.age.secrets."hosts/enka/password.said".path;
    uid                = 1000;
  };

  users.users.orhan = graphicalUser {
    description        = "Orhan";
    hashedPasswordFile = config.age.secrets."hosts/enka/password.orhan".path;
    uid                = 1001;
  };

  networking.firewall = enabled {
    allowedTCPPorts = [ 8080 ];
  };
})

(homeConfiguration {
  home.stateVersion = "23.05";
})
