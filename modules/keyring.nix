{ ulib, ... }: with ulib;

desktopSystemConfiguration {
  programs.seahorse = enabled {};

  security.pam.services.login.enableGnomeKeyring = true;

  services.gnome.gnome-keyring = enabled {};
}
