{ ulib, pkgs, theme, ... }: with ulib; merge

(desktopSystemConfiguration {
  programs.dconf = enabled {};
})

(desktopHomeConfiguration {
  gtk = enabled {
    gtk3.extraCss = theme.adwaitaGtkCss;
    gtk4.extraCss = theme.adwaitaGtkCss;

    font = with theme.font; {
      inherit (sans) name package;

      size = size.normal;
    };

    iconTheme = theme.icons;

    theme = {
      name    = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
  };
})

