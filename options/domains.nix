{ lib, ... }: {
  options = {
    mailserver.domain = lib.mkValue null;

    services.forgejo.fqdn = lib.mkValue null;
  };
}
