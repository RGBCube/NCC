{ config, lib, pkgs, ... }: with lib; merge

(desktopUserHomeConfiguration {
  xdg.configFile."Vencord/settings/quickCss.css".text = config.theme.discordCss;
})

(desktopUserHomePackages (with pkgs; [
  ((discord.override {
    withOpenASAR = true;
    withVencord  = true;
  }).overrideAttrs (old: {
    nativeBuildInputs = old.nativeBuildInputs ++ [ makeWrapper ];

    postFixup = ''
      wrapProgram $out/opt/Discord/Discord \
        --set ELECTRON_OZONE_PLATFORM_HINT "auto" \
        --add-flags "--enable-features=UseOzonePlatform --ozone-platform=wayland"
    '';
  }))
]))
