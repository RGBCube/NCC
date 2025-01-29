{ pkgs, ... }: {
  environment.systemPackages = [
    (pkgs.python311.withPackages (pkgs: [
      pkgs.pip
      pkgs.requests
    ]))

    pkgs.uv
  ];
}
