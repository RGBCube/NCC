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
    ./system
    ./users
    ./xserver
  ];
}

 //

(homeManagerConfiguration "nixos" {
  home.stateVersion = "22.11";
})
