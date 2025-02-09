{ lib, ... }: let
  inherit (lib) enabled;
in {
  environment.shellAliases.todo = /* sh */ ''rg "todo|fixme" --colors match:fg:yellow --colors match:style:bold'';

  home-manager.sharedModules = [{
    programs.ripgrep = enabled {
      arguments = [
        "--line-number"
        "--smart-case"
      ];
    };
  }];
}
