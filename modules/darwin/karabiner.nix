{ lib, ... }: let
  # inherit (lib) enabled;
  inherit (lib.strings) toJSON;

  allBasic = map (x: x // { type = "basic"; });

  simple_modifications = [
    {
      from.key_code = "caps_lock";

      to = [{ key_code = "escape"; }];
    }

    {
      from.key_code = "escape";

      to = [{ key_code = "caps_lock"; }];
    }
  ];

  complex_modifications.rules = [
    {
      description  = "Replace alt+spacebar with spacebar";
      manipulators = allBasic [
        {
          from.key_code            = "spacebar";
          from.modifiers.mandatory = [ "left_option" ];
          from.modifiers.optional  = [ "left_shift" "right_shift" ];

          to = [{ key_code = "spacebar"; }];
        }
        {
          from.key_code            = "spacebar";
          from.modifiers.mandatory = [ "right_option" ];
          from.modifiers.optional  = [ "left_shift" "right_shift" ];

          to = [{ key_code = "spacebar"; }];
        }
      ];
    }

    {
      description  = "Swap ĞğüÜ and {[]}";
      manipulators = allBasic [
        {
          from.key_code = "open_bracket";

          to = [{
            key_code  = "8";
            modifiers = [ "right_option" ];
          }];
        }
        {
          from.key_code            = "open_bracket";
          from.modifiers.mandatory = ["shift"];

          to = [{
            key_code  = "7";
            modifiers = [ "right_option" ];
          }];
        }
        {
          from.key_code = "close_bracket";

          to = [{
            key_code  = "9";
            modifiers = [ "right_option" ];
          }];
        }
        {
          from.key_code            = "close_bracket";
          from.modifiers.mandatory = [ "shift" ];

          to = [{
            key_code  = "0";
            modifiers = [ "right_option" ];
          }];
        }
        {
          from.key_code            = "8";
          from.modifiers.mandatory = [ "option" ];

          to = [{ key_code = "open_bracket"; }];
        }
        {
          from.key_code            = "7";
          from.modifiers.mandatory = [ "option" ];

          to = [{
            key_code  = "open_bracket";
            modifiers = [ "shift" ];
          }];
        }
        {
          from.key_code            = "9";
          from.modifiers.mandatory = [ "option" ];

          to = [{ key_code = "close_bracket"; }];
        }
        {
          from.key_code            = "0";
          from.modifiers.mandatory = [ "option" ];

          to = [{
            key_code  = "close_bracket";
            modifiers = [ "shift" ];
          }];
        }
      ];
    }

    {
      description = "Swap ı and i";
      manipulators = allBasic [
        {
          from.key_code = "quote";
        
          to = [{ key_code = "i"; }];
        }
        {
          from.key_code = "i";
        
          to = [{ key_code = "quote"; }];
        }
      ];
    }
  ];
in {
  # TODO: Install using Nix. Currently I'm doing it manually.

  # nixpkgs.overlays = [(self: super: {
  #   karabiner-elements = super.karabiner-elements.overrideAttrs (old: {
  #     version = "14.13.0";

  #     src = super.fetchurl {
  #       inherit (old.src) url;

  #       hash = "sha256-gmJwoht/Tfm5qMecmq1N6PSAIfWOqsvuHU8VDJY8bLw=";
  #     };
  #   });
  # })];

  # services.karabiner-elements = enabled;

  home-manager.sharedModules = [{
    xdg.configFile."karabiner/karabiner.json".text = toJSON {
      global.show_in_menu_bar = false;

      profiles = [{
        inherit complex_modifications;

        name     = "Default";
        selected = true;

        virtual_hid_keyboard.keyboard_type_v2 = "ansi";

        devices = [{
          inherit simple_modifications;

          identifiers.is_keyboard = true;
        }];
      }];
    };
  }];
}
