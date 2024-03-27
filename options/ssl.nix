{ config, lib, ... }: {
  options.sslTemplate = lib.mkConst {
    forceSSL    = true;
    quic        = true;
    useACMEHost = config.networking.domain;
  };
}
