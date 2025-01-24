inputs: self: super: let
  inherit (self) attrValues filter getAttrFromPath hasAttrByPath collect;

  commonModules = collect ../modules/common;
  nixosModules  = collect ../modules/linux;
  darwinModules = collect ../modules/darwin;

  collectInputs = let
    inputs' = attrValues inputs;
  in path: inputs'
    |> filter (hasAttrByPath path)
    |> map (getAttrFromPath path);

  inputNixosModules  = collectInputs [ "nixosModules"  "default" ];
  inputDarwinModules = collectInputs [ "darwinModules" "default" ];

  inputOverlays = collectInputs [ "overlays" "default" ];
  overlayModule = { nixpkgs.overlays = inputOverlays; };

  specialArgs = inputs // {
    inherit inputs;

    keys = import ../keys.nix;
    lib  = self;
  };
in {
  nixosSystem = module: super.nixosSystem {
    inherit specialArgs;

    modules = [
      module
      overlayModule
    ] ++ commonModules
      ++ nixosModules
      ++ inputNixosModules;
  };

  darwinSystem = module: super.darwinSystem {
    inherit specialArgs;

    modules = [
      module
      overlayModule
    ] ++ commonModules
      ++ darwinModules
      ++ inputDarwinModules;
  };
}
