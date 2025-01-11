{ config, lib, pkgs, ... }: let
  inherit (lib) getExe;
in {
  environment.sessionVariables.SHELLS = getExe config.environment.sessionVariables.SHELL;

  users.defaultUserShell = pkgs.crash;
}
