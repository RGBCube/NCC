{ ulib, pkgs, theme, ... }: with ulib; merge3

(desktopSystemConfiguration {
  nixpkgs.config.allowUnfree = true;
})

(desktopHomeConfiguration {
  xdg.configFile."Vencord/settings/quickCss.css".text = theme.discordCss;
})

(desktopHomePackages (with pkgs; [
  ((discord-canary.override {
    withOpenASAR = true;
    withVencord  = true;
  }).overrideAttrs (old: with pkgs; {
    libPath = old.libPath + ":${libglvnd}/lib";
    nativeBuildInputs = old.nativeBuildInputs ++ [ makeWrapper ];

    postFixup = ''
      wrapProgram $out/opt/DiscordCanary/DiscordCanary \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform=wayland}}"
    '';
  }))
]))
