{ lib, pkgs, theme, homeConfiguration, homePackages, ... }: lib.recursiveUpdate

(homeConfiguration "nixos" {
  xdg.configFile."Vencord/settings/quickCss.css".text = theme.discordCss;
})

(with pkgs; homePackages "nixos" [
  (discord.override {
    withOpenASAR = true;
    withVencord  = true;
  })
])
