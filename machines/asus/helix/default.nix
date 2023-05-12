{ homeConfiguration, enabled, ... }:

homeConfiguration "nixos" {
  programs.helix = enabled {
    settings.editor = {
      auto-pairs."<" = ">";
      auto-pairs."`" = "`";
      auto-save = true;
      color-modes = true;
      cursor-shape.normal = "bar";
      cursorline = true;
      file-picker.hidden = false;
      indent-guides.render = true;
      indent-guides.character = "▏";
      indent-guides.skip-levels = 1;
      line-number = "relative";
      shell = [ "nu" "-c" ];
      text-width = 100;
      whitespace.render.space = "all";
      whitespace.render.tab = "all";
      whitespace.characters.space = "·";
      whitespace.characters.tab = "→";
    };
  };
}
