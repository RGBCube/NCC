{
  enabled = attributes: attributes // {
    enable = true;
  };

  normalUser = attributes: attributes // {
    isNormalUser = true;
  };

  graphicalUser = attributes: attributes // {
    extraGroups  = [ "graphical" ] ++ (attributes.extraGroups or []);
    isNormalUser = true;
  };
}
