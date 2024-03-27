{ lib, ... }: with lib;

systemConfiguration {
  documentation = {
    doc  = disabled;
    info = disabled;

    man = enabled {
      generateCaches = true;
    };
  };
}
