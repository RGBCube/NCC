{ self, config, inputs, lib, pkgs, ... }: let
  inherit (lib) concatStringsSep const disabled filterAttrs flip isType mapAttrs mapAttrsToList merge mkAfter optionalAttrs;
  inherit (lib.strings) toJSON;

  registryMap = inputs
    |> filterAttrs (const <| isType "flake");
in {
  # We don't want this to be garbage collected away because if
  # that happens rebuilds are slow thanks to my garbage WiFi.
  environment.etc.".system-inputs.json".text = toJSON registryMap;

  nix.nixPath = registryMap
      |> mapAttrsToList (name: value: "${name}=${value}")
      |> concatStringsSep ":";

  nix.registry = registryMap // { default = inputs.nixpkgs; }
    |> mapAttrs (_: flake: { inherit flake; });

  nix.channel = disabled;

  nix.settings = (import <| self + /flake.nix).nixConfig
    |> flip removeAttrs (if config.isDarwin then [ "use-cgroups" ] else []);

  nix.gc = merge {
    automatic  = true;
    options    = "--delete-older-than 3d";
  } <| optionalAttrs config.isLinux {
    dates      = "weekly";
    persistent = true;
  };

  nix.optimise.automatic = true;

  environment.systemPackages = [
    pkgs.nh
    pkgs.nix-index
    pkgs.nix-output-monitor
  ];

  home-manager.sharedModules = [{
    programs.nushell.configFile.text = mkAfter ''
      def --wrapped nr [program: string = "", ...arguments] {
        if ($program | str contains "#") or ($program | str contains ":") {
          nix run $program -- ...$arguments
        } else {
          nix run ("default#" + $program) -- ...$arguments
        }
      }

      def --wrapped ns [...programs] {
        nix shell ...($programs | each {
          if ($in | str contains "#") or ($in | str contains ":") {
            $in
          } else {
            "default#" + $in
          }
        })
      }
    '';
  }];
}
