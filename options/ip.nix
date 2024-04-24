{ lib, ... }: {
  options.networking.ipv4 = lib.mkValue null;
  options.networking.ipv6 = lib.mkValue null;
}
