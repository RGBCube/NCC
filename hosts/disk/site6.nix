{ self, lib, ... }: with lib;

systemConfiguration {
  imports = [
    (self + /hosts/cube/acme)
    (self + /hosts/cube/nginx.nix)
    (self + /hosts/cube/site.nix)
  ];
} 
