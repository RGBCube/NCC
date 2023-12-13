{ ulib, ... }: with ulib;

homeConfiguration {
  programs.nushell.shellAliases.todo = ''rg --ignore-case "TODO|FIXME" --colors match:fg:yellow --colors match:style:bold'';

  programs.ripgrep = enabled {
    arguments = [ "--line-number" ];
  };
}
