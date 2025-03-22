{ pkgs, ... }: {
  home-manager.sharedModules = [{
    home.file.".hammerspoon/Spoons/PaperWM.spoon" = {
      recursive = true;

      source = pkgs.fetchFromGitHub {
        owner = "mogenson";
        repo  = "PaperWM.spoon";
        rev   = "41389206e739e6f48ea59ddcfc07254226f4c93f";
        hash  = "sha256-O1Pis5udvh3PUYJmO+R2Aw11/udxk3v5hf2U9SzbeqI=";
      };
    };
    home.file.".hammerspoon/Spoons/Swipe.spoon" = {
      recursive = true;

      source = pkgs.fetchFromGitHub {
        owner = "mogenson";
        repo  = "Swipe.spoon";
        rev   = "c56520507d98e663ae0e1228e41cac690557d4aa";
        hash  = "sha256-G0kuCrG6lz4R+LdAqNWiMXneF09pLI+xKCiagryBb5k=";
      };
    };

    home.file.".hammerspoon/init.lua".source = ./init.lua;
  }];
}
