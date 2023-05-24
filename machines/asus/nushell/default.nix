{ lib, pkgs, systemConfiguration, homeConfiguration, enabled, ... }: lib.recursiveUpdate

(systemConfiguration {
  users.users.nixos.shell = pkgs.nushell;
})

(homeConfiguration "nixos" {
  programs.starship = enabled {
    settings.character = {
      success_symbol = "";
      error_symbol   = "";
    };
  };

  programs.nushell = enabled {
    configFile.source = ./configuration.nu;
    envFile.source    = ./environment.nu;

    shellAliases = {
      la = "ls --all";
      sl = "ls";
    };
  };
})
