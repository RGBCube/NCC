{ config, ulib, pkgs, ... } @ inputs: with ulib; merge3

(systemConfiguration {
  users.defaultUserShell = pkgs.nushell;
})

(homeConfiguration {
  programs.starship = enabled {
    settings = {
      command_timeout = 100;
      scan_timeout    = 20;
    };
  };

  programs.nushell = enabled {
    configFile.text = import ./configuration.nix.nu inputs;
    envFile.text    = import ./environment.nix.nu inputs;

    environmentVariables = {
      inherit (config.environment.variables) NIX_LD;
    };

    shellAliases = {
      cdtmp = "cd (mktemp --directory)";

      la  = "ls --all";
      ll  = "ls --long";
      lla = "ls --long --all";
      sl  = "ls";

      cp = "cp --recursive --verbose --progress";
      mk = "mkdir";
      mv = "mv --verbose";
      rm = "rm --recursive --verbose";

      pstree = "pstree -g 2";
      tree = "tree -CF --dirsfirst";
    };
  };
})

(homePackages (with pkgs; [
  carapace
]))
