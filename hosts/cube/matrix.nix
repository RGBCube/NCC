{ config, ulib, ... }: with ulib;

# Documenting this because I found the way Matrix works a bit weird:
#
# Since it uses normal plain HTTP on ports 80 and 443, we are using
# the root domain and proxying ${domain}/_matrix to the local matrix
# instance that is running. This means there are no matrix or chat
# or whatever 3rd level domains in this setup. The server url is
# the root, everywhere.

let
  inherit (config.networking) domain;
in serverSystemConfiguration {
  age.secrets."cube/password.matrix".owner      = "matrix";
  age.secrets."cube/password.matrix.sync".owner = "matrix";

  services.postgresql = {
    ensureDatabases = [ "matrix" ];
    ensureUsers     = [{
      name = "matrix";
      ensureDBOwnership = true;
    }];
  };

  services.matrix-synapse = { # enabled {
    settings = {
      server_name = domain;
    };
  };
}
