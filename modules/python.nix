{ ulib, pkgs, ... }: with ulib; merge

(systemPackages (with pkgs; [
  (python312.withPackages (pkgs: with pkgs; [
    pip
    requests
  ]))
  virtualenv
  # poetry # Broken for some reason ATM.
]))

(homeConfiguration {
  programs.nushell.shellAliases = {
    venv = "virtualenv venv";
  };
})
