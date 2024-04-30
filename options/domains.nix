{ lib, ... }: {
  options.services.forgejo.fqdn = lib.mkValue null;
}
