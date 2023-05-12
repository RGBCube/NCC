{ pkgs, systemConfiguration, homeConfiguration, enabled, ... }:

(systemConfiguration {
  users.defaultUserShell = pkgs.nushell;
})

//

(homeConfiguration "nixos" {
  programs.starship = enabled {
    settings.character = {
      success_symbol = "";
      error_symbol = "";
    };
  };

  programs.nushell = enabled {
    configFile.source = ./configuration.nu;
    envFile.source = ./environment.nu;

    shellAliases = {
      la = "ls -a";
      sl = "ls";
    };
  };
})
