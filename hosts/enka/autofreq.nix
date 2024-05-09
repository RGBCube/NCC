{ lib, ... }: with lib;

systemConfiguration {
  services.auto-cpufreq = enabled;
}
