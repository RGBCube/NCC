{ lib, pkgs, upkgs, homeConfiguration, homePackages, ... }: lib.recursiveUpdate

(homeConfiguration "nixos" {
  xdg.configFile."Vencord/settings/quickCss.css".text = upkgs.theme.discordCss;
})

(with pkgs; homePackages "nixos" [
  (discord.override {
    withOpenASAR = true;
    withVencord  = true;
  })
])
