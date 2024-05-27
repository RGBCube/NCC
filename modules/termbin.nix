{ lib, ... }: with lib;

systemConfiguration {
  environment.shellAliases.tb = "nc termbin.com 9999";
}
