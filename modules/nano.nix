{ lib, ... }: with lib;

systemConfiguration {
  environment.defaultPackages = [];

  programs.nano = disabled; # Garbage.
}
