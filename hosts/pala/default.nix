{ config, lib, ... }: with lib; merge

(systemConfiguration {
  system.stateVersion  = "24.11";
  nixpkgs.hostPlatform = "aarch64-linux";

  time.timeZone = "Europe/Istanbul";

  secrets.saidPassword.file  = ./password.said.age;

  users.users = {
    root.hashedPasswordFile = config.secrets.saidPassword.path;

    said = sudoUser (desktopUser {
      description        = "Said";
      hashedPasswordFile = config.secrets.saidPassword.path;
    });
  };
})

(homeConfiguration {
  home.stateVersion = "24.11";
})

