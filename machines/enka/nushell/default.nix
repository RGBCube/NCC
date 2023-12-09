{ config, pkgs, ulib, theme, systemConfiguration, homeConfiguration, homePackages, enabled, ... }: ulib.recursiveUpdate3

(systemConfiguration {
  users.defaultUserShell = pkgs.nushell;
})

(homeConfiguration [ "nixos" "root" ] {
  programs.starship = enabled {};

  programs.nushell = enabled {
    configFile.text = import ./configuration.nix.nu;
    envFile.text = import ./environment.nix.nu {
      inherit (ulib) nuScripts;
      inherit theme;
    };

    environmentVariables = {
      inherit (config.environment.variables) NIX_LD;
    };

    shellAliases = {
      cdtmp = "cd (mktemp --directory)";

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
