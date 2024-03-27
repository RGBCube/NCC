{ config, ulib, keys, ... }: with ulib; merge

(systemConfiguration {
  system.stateVersion  = "23.05";
  nixpkgs.hostPlatform = "x86_64-linux";

  networking.domain = "rgbcu.be";

  time.timeZone = "Europe/Amsterdam";

  age.secrets."hosts/cube/password.rgb".file = ./password.rgb.age;

  users.users.root.hashedPasswordFile = config.age.secrets."hosts/cube/password.rgb".path;

  users.users.rgb = normalUser {
    description                 = "RGB";
    extraGroups                 = [ "wheel" ];
    openssh.authorizedKeys.keys = [ keys.enka ];
    hashedPasswordFile          = config.age.secrets."hosts/cube/password.rgb".path;
  };
})

(homeConfiguration {
  home.stateVersion = "23.11";
})
