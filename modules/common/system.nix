{ config, lib, ... }: let
  inherit (lib) any elem last mapAttrsToList mkConst splitString;
in {
  options = {
    os = mkConst <| last <| splitString "-" config.nixpkgs.hostPlatform.system;

    isLinux  = mkConst <| config.os == "linux";
    isDarwin = mkConst <| config.os == "darwin";

    isDesktop = mkConst <| config.isDarwin || (any <| mapAttrsToList (_: value: elem "graphical" value.extraGroups) config.users.users);
    isServer  = mkConst <| !config.isDesktop;
  };
}
