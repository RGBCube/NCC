{ pkgs, homeConfiguration, systemPackages, enabled, ... }:

(with pkgs; systemPackages [
  (python311.withPackages (pkgs: with pkgs; [
    pip
    requests
  ]))
  virtualenv
  poetry
])

//

(homeConfiguration "nixos" {
  programs.nushell.shellAliases = {
    vv = "virtualenv venv";
  };
})
