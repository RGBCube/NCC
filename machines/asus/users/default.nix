{ pkgs, ... }:

{
  users.defaultUserShell = pkgs.nushell;

  imports = [
    ./nixos.nix
  ];
}
