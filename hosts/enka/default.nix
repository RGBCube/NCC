{ ulib, ... }: with ulib; merge

(systemConfiguration {
  system.stateVersion = "23.05";

  nixpkgs.hostPlatform = "x86_64-linux";

  time.timeZone = "Europe/Istanbul";

  users.users.said = graphicalUser {
    description = "Said";
    extraGroups = [ "wheel" ];
    uid         = 1000;
  };

  users.users.orhan = graphicalUser {
    description = "Orhan";
    uid         = 1001;
  };

  networking.firewall = enabled {
    allowedTCPPorts = [ 8080 ];
  };
})

(homeConfiguration {
  home.stateVersion = "23.05";
})
