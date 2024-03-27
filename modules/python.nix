{ lib, pkgs, ... }: with lib; merge

(systemConfiguration {
  environment.shellAliases = {
    venv = "virtualenv venv";
  };
})

(systemPackages (with pkgs; [
  (python311.withPackages (pkgs: with pkgs; [
    pip
    requests
  ]))
  virtualenv
  poetry
]))
