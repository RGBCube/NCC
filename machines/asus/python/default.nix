{ pkgs, homeConfiguration, packages, enabled, ... }:

(with pkgs; packages [
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
