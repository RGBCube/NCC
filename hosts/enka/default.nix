{ ulib, ... }: with ulib; merge

(systemConfiguration {
  system.stateVersion = "23.05";

  nixpkgs.hostPlatform = "x86_64-linux";

  time.timeZone = "Europe/Istanbul";

  users.users.nixos = graphicalUser {
    description = "NixOS";
    extraGroups = [ "wheel" ];
  };

  users.users.orhan = graphicalUser {
    description = "Orhan";
  };

  networking.firewall = enabled {
    allowedTCPPorts = [ 8080 ];
  };
})

(homeConfiguration {
  home.stateVersion = "23.05";
})
