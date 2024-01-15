{ ulib, ... }: with ulib;

systemConfiguration {
  environment.defaultPackages = [];

  programs.nano.enable = false; # Garbage.
}
