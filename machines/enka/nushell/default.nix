{ lib, pkgs, systemConfiguration, homeConfiguration, homePackages, enabled, ... }: lib.recursiveUpdate3

(systemConfiguration {
  users.users.nixos.shell = pkgs.nushell;

  environment.shellAliases = {
    la  = "ls --all";
    lla = "ls --long --all";
    sl  = "ls";
  };
})

(homeConfiguration "nixos" {
  programs.starship = enabled {};

  programs.nushell = enabled {
    configFile.source = ./configuration.nu;
    envFile.source    = ./environment.nu;
  };
})

(with pkgs; homePackages "nixos" [
  carapace
])
