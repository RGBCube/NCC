inputs: self: super: let
  inherit (self) attrValues filter getAttrFromPath hasAttrByPath hasSuffix;
  inherit (self.filesystem) listFilesRecursive;

  collect = path: listFilesRecursive path
    |> filter (hasSuffix ".nix");

  commonModules = collect ../modules/common;
  nixosModules  = collect ../modules/nixos;
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
in {
  nixosSystem = module: super.nixosSystem {
    modules = [
      module
      overlayModule
    ] ++ commonModules
      ++ nixosModules
      ++ inputNixosModules;

    specialArgs = inputs // {
      inherit inputs;

      lib = self;
    };
  };

  darwinSystem = module: super.darwinSystem {
    modules = [
      module
      overlayModule
    ] ++ commonModules
      ++ darwinModules
      ++ inputDarwinModules;

    specialArgs = inputs // {
      inherit inputs;

      lib = self;
    };
  };
}
