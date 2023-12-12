{ config, ulib, pkgs, upkgs, theme, ... }: with ulib; merge

(systemConfiguration {
  users.defaultUserShell = pkgs.nushell;
})

(homeConfiguration {
  programs.carapace = enabled {};
  programs.starship = enabled {};

  programs.nushell = enabled {
    configFile.text = import ./configuration.nix.nu;
    envFile.text = import ./environment.nix.nu {
      inherit (upkgs) nuScripts;
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
