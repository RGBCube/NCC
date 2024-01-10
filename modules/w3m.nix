{ ulib, pkgs, ... }: with ulib; merge

(systemPackages (with pkgs; [
  w3m
]))

(homeConfiguration {
  programs.nushell.shellAliases = {
    ddg = "w3m lite.duckduckgo.com";
    web = "w3m";
  };
})
