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
      g = "git";
      ga = "git add ./";
      gb = "git rebase -i";
      gc = "git commit -m";
      gca = "git commit --amend";
      gcl = "git clone";
      gd = "git diff";
      gds = "git diff --staged";
      gp = "git push";
      gs = "git status";

      la = "ls -a";
      sl = "ls";

      p = "python3";
    };
  };
})
