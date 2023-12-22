{ ulib, ... }: with ulib;

systemConfiguration {
  services.auto-cpufreq = enabled {};
}
