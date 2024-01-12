{ config, ulib, ... }: with ulib; merge

(systemConfiguration {
  system.stateVersion = "23.05";

  nixpkgs.hostPlatform = "x86_64-linux";

  time.timeZone = "Europe/Istanbul";

  users.users.root.hashedPasswordFile = config.age.secrets."enka.said.password.hash".path;

  users.users.said = graphicalUser {
    description        = "Said";
    extraGroups        = [ "wheel" ];
    hashedPasswordFile = config.age.secrets."enka.said.password.hash".path;
    uid                = 1000;
  };

  users.users.orhan = graphicalUser {
    description        = "Orhan";
    hashedPasswordFile = builtins.trace (config.age.secrets) config.age.secrets."enka.orhan.password.hash".path;
    uid                = 1001;
  };

  networking.firewall = enabled {
    allowedTCPPorts = [ 8080 ];
  };
})

(homeConfiguration {
  home.stateVersion = "23.05";
})
