{ lib, ... }: let
  userOptions.options.isDesktopUser = lib.mkOption {
    type    = lib.types.bool;
    default = false;
  };
in {
  options.users.users = lib.mkOption {
    type = with lib.types; attrsOf (submodule userOptions);
  };
}
