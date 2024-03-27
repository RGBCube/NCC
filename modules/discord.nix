{ config, lib, pkgs, ... }: with lib; merge

(desktopSystemConfiguration {
  nixpkgs.config.allowUnfree = true;
})

(desktopUserHomeConfiguration {
  xdg.configFile."Vencord/settings/quickCss.css".text = config.theme.discordCss;
})

(desktopUserHomePackages (with pkgs; [
  (discord.override {
    withOpenASAR = true;
    withVencord  = true;
  })
]))
