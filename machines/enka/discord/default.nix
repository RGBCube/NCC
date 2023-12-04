{ lib, pkgs, upkgs, homeConfiguration, homePackages, ... }: lib.recursiveUpdate

(homeConfiguration "nixos" {
  xdg.configFile."Vencord/settings/quickCss.css".text = upkgs.theme.discordCss;
})

(with pkgs; homePackages "nixos" [
  ((discord.override {
    withOpenASAR = true;
    withVencord  = true;
  }).overrideAttrs (old: with pkgs; {
    libPath = old.libPath + ":${libglvnd}/lib";
    nativeBuildInputs = old.nativeBuildInputs ++ [ makeWrapper ];

    postFixup = ''
      wrapProgram $out/opt/Discord/Discord --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform=wayland}}"
    '';
  }))
])
