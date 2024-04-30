{ lib, ... }: {
  options.networking = {
    ipv4 = lib.mkValue null;
    ipv6 = lib.mkValue null;
  };
}
