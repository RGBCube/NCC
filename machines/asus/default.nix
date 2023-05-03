{ homeManagerConfiguration, ... }:

{
  system.stateVersion = "22.11";

  imports = [
    ./docker
    ./git
    ./neovim
    ./networkmanager
    ./nixpkgs
    ./nushell
    ./pipewire
#    ./plasma
    ./system
    ./users
    ./xserver
  ];
}

# //
#
# (homeManagerConfiguration {
#   imports = [
#       plasma-manager.homeManagerModules.plasma-manager
#   ];
# })
