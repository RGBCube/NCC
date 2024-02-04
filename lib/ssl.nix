{
  sslTemplate = domain: {
    forceSSL    = true;
    quic        = true;
    useACMEHost = domain;
  };
}
