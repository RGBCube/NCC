{ lib, pkgs, systemConfiguration, homeConfiguration, homePackages, enabled, ... }: lib.recursiveUpdate3

(systemConfiguration {
  users.defaultUserShell = pkgs.nushell;
})

(homeConfiguration [ "nixos" "root" ] {
  programs.starship = enabled {};

  programs.nushell = enabled {
    configFile.source = ./configuration.nu;
    envFile.source    = ./environment.nu;

    shellAliases = {
      la  = "ls --all";
      ll  = "ls --long";
      lla = "ls --long --all";
      sl  = "ls";

      pstree = "pstree -g 2";
      tree = "tree -C";
    };
  };
})

(with pkgs; homePackages "nixos" [
  carapace
])
