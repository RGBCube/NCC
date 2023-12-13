{ config, ulib, pkgs, upkgs, theme, ... }: with ulib; merge3

(systemConfiguration {
  users.defaultUserShell = pkgs.nushell;
})

(homeConfiguration {
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

      cp = "cp --verbose --progress";
      mk = "mkdir";
      mv = "mv --verbose";

      pstree = "pstree -g 2";
      tree = "tree -CF --dirsfirst";
    };
  };
})

(homePackages (with pkgs; [
  carapace
]))
