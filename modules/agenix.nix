{ lib, pkgs, ... }: with lib; merge

(systemConfiguration {
  age.identityPaths = [ "/root/.ssh/id" ];
})

(desktopSystemConfiguration {
  environment.shellAliases.agenix = "agenix --identity ~/.ssh/id";
})

(desktopSystemPackages (with pkgs; [
  agenix
]))
