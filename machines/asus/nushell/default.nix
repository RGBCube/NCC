{ homeManagerConfiguration, ... }:

homeManagerConfiguration "nixos" {
  programs.starship.enable = true;
  programs.starship.settings.character = {
    success_symbol = "";
    error_symbol = "";
  };

  programs.nushell.enable = true;
  programs.nushell = {
    configFile.source = ./config.nu;
    envFile.source = ./env.nu;

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

      e = "neovim";
      p = "python3";
    };
  };
}
