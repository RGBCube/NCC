{ homeConfiguration, enabled, ... }:

homeConfiguration "nixos" {
  programs.nushell = {
    environmentVariables = {
      EDITOR = "hx";
    };

    shellAliases = {
      e = "hx";
    };
  };

  programs.helix = enabled {
    settings.theme = "gruvbox";

    settings.editor = {
      auto-pairs."<" = ">";
      auto-pairs."`" = "`";
      auto-save = true;
      color-modes = true;
      cursor-shape.normal = "bar";
      cursorline = true;
      file-picker.hidden = false;
      line-number = "relative";
      shell = [ "nu" "-c" ];
      text-width = 100;
      whitespace.render.tab = "all";
      whitespace.characters.tab = "→";
    };
  };
}
