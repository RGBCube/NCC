{ pkgs, ... }:

{
  nixpkgs.hostPlatform = "x86_64-linux";

  environment.systemPackages = import ./packages.nix pkgs;
  fonts.fonts = import ./fonts.nix pkgs;
}
