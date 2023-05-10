{ lib, pkgs, systemConfiguration, homeConfiguration, packages, enabled, projectPath, ... }:

(systemConfiguration {
  environment.defaultPackages = [];
  programs.nano.syntaxHighlight = false;
})

//

(with pkgs; packages [
  neovim-qt
])

//

(homeConfiguration "nixos" ({ config, ... }: {
  programs.neovim = enabled {
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  # NvChad
  home.file.".config/nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink projectPath + "/machines/asus/neovim/nvchad";
  };
}))
