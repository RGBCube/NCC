{ pkgs, lib, homeManagerConfiguration, ... }:

{
  # Nuking nano out of orbit.
  environment.defaultPackages = [];
  programs.nano.syntaxHighlight = false;
}

//

(homeManagerConfiguration "nixos" {
  programs.neovim.enable = true;
  programs.neovim = {
    defaultEditor = true;

    viAlias = true;
    vimAlias = true;

    plugins = [
      # lunarVim
    ];
  };

  # NvChad
  home.file.".config/nvim" = {
    source = pkgs.callPackage ../../../packages/nvchad {};
    recursive = true;
  };

  home.file.".config/nvim/lua/custom" = {
    source = ./config;
    recursive = true;
    force = true;
  };
})
