{ homeManagerConfiguration, ... }:

homeManagerConfiguration {
  # Nuking nano out of orbit.
  environment.defaultPackages = [];
  programs.nano.syntaxHighlight = false;

  programs.neovim.enable = true;
  programs.neovim = {
    defaultEditor = true;

    viAlias = true;
    vimAlias = true;

    plugins = [
      # lunarVim
    ];
  };
}
