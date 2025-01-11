{ pkgs, ... }: {
  environment.shellAliases = {
    ddg = "w3m lite.duckduckgo.com";
    web = "w3m";
  };

  environment.systemPackages = [
    pkgs.w3m
  ];
}
