{ config, lib, ... }: let
  inherit (lib) any elem getAttr last mapAttrsToList mkConst splitString;
in {
  options = {
    os = mkConst <| last <| splitString "-" config.nixpkgs.hostPlatform.system;

    isLinux  = mkConst <| config.os == "linux";
    isDarwin = mkConst <| config.os == "darwin";

    isDesktop = mkConst <| config.isDarwin || false; # (any (elem "graphical") <| mapAttrsToList (_: getAttr "extraGroups") config.users.users);
    isServer  = mkConst <| !config.isDesktop;
  };
}
