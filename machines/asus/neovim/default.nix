{ pkgs, lib, homeManagerConfiguration, projectPath, ... }:

{
  # Nuking nano out of orbit.
  environment.defaultPackages = [];
  programs.nano.syntaxHighlight = false;

  environment.systemPackages = with pkgs; [
    neovim-qt
  ];
}

//

(homeManagerConfiguration "nixos" ({ config, ... }: {
  programs.neovim.enable = true;
  programs.neovim = {
    # Does not work with Nushell for some reason, I just set it manually.
    # defaultEditor = true;

    viAlias = true;
    vimAlias = true;
  };

  # NvChad
  home.file.".config/nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink projectPath + "/machines/asus/neovim/nvchad";
  };
}))
