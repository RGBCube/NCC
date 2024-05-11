{ config, lib, pkgs, ... }: with lib; merge

(desktopUserHomeConfiguration {
  xdg.configFile."Vencord/settings/quickCss.css".text = config.theme.discordCss;
})

(desktopUserHomePackages (with pkgs; [
  (discord.override {
    withOpenASAR = true;
    withVencord  = true;
  })
]))
