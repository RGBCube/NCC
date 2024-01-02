{ ulib, lib, pkgs, upkgs, ... }: with ulib; merge

(homeConfiguration {
  programs.nushell.environmentVariables.EDITOR = "hx";
  programs.nushell.shellAliases.x              = "hx";

  programs.helix = enabled {
    languages.language = [
      {
        name = "nix";

        auto-format       = false;
        formatter.command = "alejandra";
        formatter.args    = [ "-" ];
      }
      {
        name            = "cull";
        injection-regex = "cull";
        scope           = "scope.cull";

        comment-token    = "#";
        indent.unit      = "\t";
        indent.tab-width = 4;

        file-types = [ "cull" ];
        roots      = [ "build.cull" ];

        grammar = "python";
      }
    ];

    settings.theme = "gruvbox_dark_hard";

    settings.editor = {
      color-modes            = true;
      completion-replace     = true;
      completion-trigger-len = 0;
      cursor-shape.insert    = "bar";
      cursorline             = true;
      bufferline             = "multiple";
      file-picker.hidden     = false;
      idle-timeout           = 300;
      line-number            = "relative";
      shell                  = [ "bash" "-c" ];
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

    settings.keys = lib.genAttrs [ "normal" "select" ] (name: {
      D = "extend_to_line_end";
    });
  };
})

(desktopSystemPackages (with pkgs; [
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
  alejandra
  nil

  # PYTHON
  python311Packages.python-lsp-server

  # RUST
  rust-analyzer-nightly

  # ZIG
  upkgs.zls
]))
