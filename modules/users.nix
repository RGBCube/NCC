{ lib, ... }: with lib;

systemConfiguration {
  users.mutableUsers = false;
}
