{ pkgs, lib, homeManagerConfigurationWithArgs, projectPath, ... }:

{
  # Nuking nano out of orbit.
  environment.defaultPackages = [];
  programs.nano.syntaxHighlight = false;
}

//

(homeManagerConfigurationWithArgs "nixos" ({ config, ... }: {
  programs.neovim.enable = true;
  programs.neovim = {
    defaultEditor = true;

    viAlias = true;
    vimAlias = true;
  };

  # NvChad
  home.file.".config/nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink projectPath + "/machines/asus/neovim/nvchad";
  };
}))
