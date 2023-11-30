{ pkgs, systemConfiguration, enabled, ... }:

systemConfiguration {
  services.greetd = enabled {
    settings.default_session = {
      command = "${pkgs.cage}/bin/cage -sd ${pkgs.greetd.gtkgreet}/bin/gtkgreet";
      user    = "nixos";
    };
  };

  environment.etc."greetd/environments".text = ''
    Hyprland
    bash
    nu
    sh
  '';
}
