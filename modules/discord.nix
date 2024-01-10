{ ulib, pkgs, theme, ... }: with ulib; merge3

(desktopSystemConfiguration {
  nixpkgs.config.allowUnfree = true;
})

(desktopHomeConfiguration {
  xdg.configFile."Vencord/settings/quickCss.css".text = theme.discordCss;
})

(desktopSystemPackages (with pkgs; [
  (discord.override {
    withOpenASAR = true;
    withVencord  = true;
  })
]))
