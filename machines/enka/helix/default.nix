{ lib, pkgs, homeConfiguration, homePackages, enabled, ... }: lib.recursiveUpdate

(homeConfiguration [ "nixos" "root" ] {
  programs.nushell.environmentVariables.EDITOR = "hx";
  programs.nushell.shellAliases.x              = "hx";

  programs.helix = enabled {
    settings.theme = "base16_transparent";

    settings.editor = {
      color-modes            = true;
      completion-replace     = true;
      completion-trigger-len = 0;
      cursor-shape.insert    = "bar";
      cursorline             = true;
      bufferline             = "multiple";
      file-picker.hidden     = false;
      idle-timeout           = 200;
      line-number            = "relative";
      shell                  = [ "nu" "--commands" ];
      text-width             = 100;
    };

    settings.editor.indent-guides = {
      character = "▏";
      render = true;
    };

    settings.editor.statusline.mode = {
      insert = "INSERT";
      normal = "NORMAL";
      select = "SELECT";
    };

    settings.editor.whitespace = {
      characters.tab = "→";
      render.tab     = "all";
    };

    settings.keys = lib.genAttrs [ "normal" "select" ] (_: {
      D = "extend_to_line_end";
    });
  };
})

(with pkgs; homePackages "nixos" [
  # CMAKE
  cmake-language-server

  # GO
  gopls

  # HTML
  vscode-langservers-extracted

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

  # PYTHON
  python311Packages.python-lsp-server

  # RUST
  rust-analyzer

  # ZIG
  zls
])
