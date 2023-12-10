{ ulib, pkgs, theme, ... }: with ulib; merge

(graphicalConfiguration {
  xdg.configFile."Vencord/settings/quickCss.css".text = theme.discordCss;
})

(graphicalPackages (with pkgs; [
  (discord.override {
    withOpenASAR = true;
    withVencord  = true;
  })
]))
