{ pkgs, ... }:

{
  users.defaultShell = pkgs.nushell;

  imports = [
    ./nixos.nix
  ];
}
