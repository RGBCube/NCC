{ pkgs, ... }:

{
  environment.systemPackages = import ./packages.nix pkgs;
  fonts.fonts = import ./fonts.nix pkgs;
}
