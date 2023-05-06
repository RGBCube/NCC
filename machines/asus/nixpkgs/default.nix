{ pkgs, fenix, ... } @ args:

{
  environment.systemPackages = import ./packages.nix args;
  fonts.fonts = import ./fonts.nix args;
}
