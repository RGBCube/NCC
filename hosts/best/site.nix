{ self, ... }: {
  imports = [(self + /modules/site.nix)];
}
