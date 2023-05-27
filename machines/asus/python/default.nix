{ lib, pkgs, systemPackages, homeConfiguration, ... }: lib.recursiveUpdate

(with pkgs; systemPackages [
  (python311.withPackages (pkgs: with pkgs; [
    pip
    requests
  ]))
  virtualenv
  poetry
])

(homeConfiguration "nixos" {
  programs.nushell.envFile.source = ''
    def venv [] {
      virtualenv venv
      source ./venv/bin/activate.nu
    }
  '';
})
