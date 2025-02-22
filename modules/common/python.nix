{ pkgs, ... }: {
  environment.systemPackages = [
    pkgs.python314
    pkgs.uv
  ];
}
