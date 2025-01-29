{ config, lib, ... }: let
  inherit (lib) enabled merge mkIf optionalString;
in merge {
  security.sudo = enabled {
    execWheelOnly = true;
    extraConfig   = ''
      Defaults lecture = never
      Defaults pwfeedback
      Defaults env_keep += "DISPLAY EDITOR PATH"
      ${optionalString config.isServer ''
        Defaults timestamp_timeout = 0
      ''}
    '';

    extraRules = [{
      groups   = [ "wheel" ];
      commands = let
        system = "/run/current-system";
        store = "/nix/store";
      in [
        {
          command = "${store}/*/bin/switch-to-configuration";
          options = [ "SETENV" "NOPASSWD" ];
        }
        {
          command = "${system}/sw/bin/nix system activate";
          options = [ "NOPASSWD" ];
        }
        {
          command = "${system}/sw/bin/nix system apply";
          options = [ "NOPASSWD" ];
        }
        {
          command = "${system}/sw/bin/nix system boot";
          options = [ "NOPASSWD" ];
        }
        {
          command = "${system}/sw/bin/nix system build";
          options = [ "NOPASSWD" ];
        }
        {
          command = "${system}/sw/bin/nix-collect-garbage";
          options = [ "SETENV" "NOPASSWD" ];
        }
        {
          command = "${system}/sw/bin/nix-env";
          options = [ "SETENV" "NOPASSWD" ];
        }
        {
          command = "${system}/sw/bin/nix-store";
          options = [ "SETENV" "NOPASSWD" ];
        }
        {
          command = "${system}/sw/bin/nixos-rebuild";
          options = [ "NOPASSWD" ];
        }
        {
          command = "${system}/sw/bin/systemctl";
          options = [ "NOPASSWD" ];
        }
      ];
    }];
  };
} <| mkIf config.isDesktop {
  security.sudo.wheelNeedsPassword = false;
}
