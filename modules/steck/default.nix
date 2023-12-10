{ ulib, pkgs, ... }: with ulib; merge

(systemPackages (with pkgs; [
  steck
]))

(homeConfiguration {
  programs.nushell.shellAliases.share = "steck paste";
})
