{ pkgs, systemConfiguration, homeConfiguration, packages, enabled, projectPath, ... }:

(systemConfiguration {
  environment.defaultPackages = [];
  programs.nano.syntaxHighlight = false;
})

//

(with pkgs; packages [
  neovide
])

//

(homeConfiguration "nixos" ({ config, ... }: {
  programs.nushell.environmentVariables = {
    EDITOR = "nvim";
  };

  programs.neovim = enabled {
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

#  home.file.".config/nvim" = {
#    source = config.lib.file.mkOutOfStoreSymlink projectPath + "/machines/asus/neovim";
#  };
}))
