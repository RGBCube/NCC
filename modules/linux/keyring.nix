{ lib, ... }: let
  inherit (lib) enabled;
in {
  programs.seahorse = enabled;

  security.pam.services.login.enableGnomeKeyring = true;

  services.gnome.gnome-keyring = enabled;
}
