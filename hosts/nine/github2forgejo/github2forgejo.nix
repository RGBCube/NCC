{ config, lib, ... }: with lib;

systemConfiguration {
  secrets.github2forgejoEnvironment = {
    file  = ./environment.age;
    owner = "github2forgejo";
  };

  services.github2forgejo = enabled {
    environmentFile = config.secrets.github2forgejoEnvironment.path;
  };
}
