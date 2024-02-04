{ ulib, pkgs, theme, ... }: with ulib; merge3

(desktopSystemConfiguration {
  nixpkgs.config.allowUnfree = true;
})

(desktopHomeConfiguration {
  xdg.configFile."Vencord/settings/quickCss.css".text = theme.discordCss;
})

(desktopHomePackages (with pkgs; [
  (discord-canary.override {
    withOpenASAR = true;
    withVencord  = true;
  })
]))
