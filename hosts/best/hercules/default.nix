{ self, config, lib, ... }: let
  inherit (lib) enabled genAttrs removeAttrs;
in {
  secrets.awsCredentials = {
    file  = ./credentials.age;
    owner = "hercules-ci-agent";
  };

  secrets.herculesCaches = {
    file  = ./caches.age;
    owner = "hercules-ci-agent";
  };
  secrets.herculesToken = {
    file  = ./token.age;
    owner = "hercules-ci-agent";
  };
  secrets.herculesSecrets = {
    file  = ./secrets.age;
    owner = "hercules-ci-agent";
  };

  home-manager.users = genAttrs [ "hercules-ci-agent" "root" ] (_: homeArgs: let
    homeLib    = homeArgs.config.lib;
  in {
    home.file.".aws/credentials".source = homeLib.file.mkOutOfStoreSymlink config.secrets.awsCredentials.path;
  });

  services.hercules-ci-agent = enabled {
    settings = {
      binaryCachesPath     = config.secrets.herculesCaches.path;
      clusterJoinTokenPath = config.secrets.herculesToken.path;
      secretsJsonPath      = config.secrets.herculesSecrets.path;

      nixSettings = removeAttrs (import <| self + /flake.nix).nixConfig [
        "extra-substituters"
        "extra-trusted-private-keys"
      ];
    };
  };
}
