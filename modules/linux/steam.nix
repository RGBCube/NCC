{ config, pkgs, lib, ... }: let
  inherit (lib) enabled merge mkIf;
in merge <| mkIf config.isDesktop {
  programs.steam = enabled;
}
