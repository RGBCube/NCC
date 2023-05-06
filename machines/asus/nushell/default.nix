{ homeManagerConfiguration, ... }:

homeManagerConfiguration {
  programs.nushell.enable = true;
  programs.nushell = {
    configFile.source = ./config.nu;
    envFile.source = ./env.nu;

    shellAliases = {
      g = "git";
      ga = "git add";
      gb = "git branch";
      gc = "git commit -m";
      gca = "git commit --amend";
      gcl = "git clone";
      gp = "git push";
      grb = "git rebase -i";
      grba = "git rebase --abort";
      gs = "git switch";
      gsm = "git switch master";

      la = "ls -a";
      sl = "ls";

      n = "neovim";
      p = "python3";
    };
  };
}
