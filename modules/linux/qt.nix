{ config, lib, ... }: let
  inherit (lib) enabled merge mkIf;
in merge <| mkIf config.isDesktop {
  home-manager.sharedModules = [{
    qt = enabled {
      platformTheme.name = "adwaita";
      style.name         = "adwaita";
    };
  }];
}
