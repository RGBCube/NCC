lib: lib.darwinSystem {
  type = "desktop";

  networking.hostName = "pala";

  users.users.pala = {
    name = "pala";
    home = "/Users/pala";
  };

  home-manager.users.pala.home = {
    stateVersion  = "25.05";
    homeDirectory = "/Users/pala";
  };

  nixpkgs.hostPlatform = "aarch64-darwin";
  system.stateVersion  = 5;
}
