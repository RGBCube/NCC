{ lib, ... }: let
  inherit (lib) mkConst;
in {
  options.dnsServers = mkConst [
    "45.90.28.0#7f2bf8.dns.nextdns.io"
    "2a07:a8c0::#7f2bf8.dns.nextdns.io"
    "45.90.30.0#7f2bf8.dns.nextdns.io"
    "2a07:a8c1::#7f2bf8.dns.nextdns.io"
  ];

  options.fallbackDnsServers = mkConst [
    "1.1.1.1#one.one.one.one"
    "2606:4700:4700::1111#one.one.one.one"

    "1.0.0.1#one.one.one.one"
    "2606:4700:4700::1001#one.one.one.one"

    "8.8.8.8#dns.google"
    "2001:4860:4860::8888#dns.google"

    "8.8.4.4#dns.google"
    "2001:4860:4860::8844#dns.google"
  ];
}
