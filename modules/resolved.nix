{ self, lib, ... }: with lib;

systemConfiguration {
  services.resolved = enabled {
    domains = [ self.cube.networking.domain ];

    dnsovertls  = "opportunistic";
    fallbackDns = [
      "1.1.1.1#one.one.one.one"
      "2606:4700:4700::1111#one.one.one.one"
      "8.8.8.8#dns.google"
      "2001:4860:4860::8844#dns.google"
    ];
  };
}
