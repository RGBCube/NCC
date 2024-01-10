{ ulib, ... }: with ulib;

homeConfiguration {
  programs.nushell.shellAliases = {
    rg   = "rg --line-number --smart-case";
    todo = ''rg "todo|fixme" --colors match:fg:yellow --colors match:style:bold'';
  };

  programs.ripgrep = enabled {};
}
