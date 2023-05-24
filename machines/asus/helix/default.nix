{ lib, pkgs, systemPackages, homeConfiguration, homePackages, enabled, ... }: lib.recursiveUpdate3

(with pkgs; systemPackages [
  xclip
])

(homeConfiguration "nixos" {
  programs.nushell.environmentVariables = {
    EDITOR = "hx";
  };

  programs.helix = enabled {
    settings.theme = "catppuccin_mocha";

    settings.editor = {
      color-modes         = true;
      cursor-shape.insert = "bar";
      cursorline          = true;
      file-picker.hidden  = false;
      line-number         = "relative";
      shell               = [ "nu" "-c" ];
      text-width          = 100;
    };

    settings.editor.auto-pairs = {
      "(" = ")";
      "{" = "}";
      "[" = "]";
      "\"" = "\"";
      "'" = "'";
      "<" = ">";
      "`" = "`";
    };

    settings.editor.statusline.mode = {
      normal = "NORMAL";
      insert = "INSERT";
      select = "SELECT";
    };

    settings.editor.whitespace = {
      render.tab     = "all";
      characters.tab = "→";
    };
  };
})

(with pkgs; homePackages "nixos" [
  # CMAKE
  cmake-language-server

  # GO
  gopls

  # KOTLIN
  kotlin-language-server

  # LATEX
  texlab

  # LUA
  lua-language-server

  # MARKDOWN
  marksman

  # NIX
  nil

  # RUST
  rust-analyzer

  # ZIG
  zls
])
