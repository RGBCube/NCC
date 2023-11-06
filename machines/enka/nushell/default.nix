{ lib, pkgs, systemConfiguration, homeConfiguration, homePackages, enabled, ... }: lib.recursiveUpdate3

(systemConfiguration {
  users.users.nixos.shell = pkgs.nushell;
})

(homeConfiguration "nixos" {
  programs.starship = enabled {};

  programs.nushell = enabled {
    configFile.source = ./configuration.nu;
    envFile.source    = ./environment.nu;

    shellAliases = {
      la  = "ls --all";
      lla = "ls --long --all";
      sl  = "ls";
    };
  };
})

(with pkgs; homePackages "nixos" [
  carapace
])
