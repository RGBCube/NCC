{ config, lib, ... }: let
  inherit (lib) attrNames filterAttrs hasPrefix head;
in {
  system.primaryUser = head <| attrNames <| filterAttrs (_: value: value.home != null && hasPrefix "/Users/" value.home) config.users.users;
}
