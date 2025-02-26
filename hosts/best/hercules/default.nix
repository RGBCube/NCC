{ self, config, lib, ... }: let
  inherit (lib) enabled removeAttrs;
in {
  secrets.herculesCredentials = {
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

  systemd.services.hercules-ci-agent.environment = {
    AWS_SHARED_CREDENTIALS_FILE = config.secrets.herculesCredentials.path;

    # AWS SDK is incredibly gay and will continuously try to contact 169.254.169.254 for EC2 metadata.
    AWS_EC2_METADATA_DISABLED = "true";
  };

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
