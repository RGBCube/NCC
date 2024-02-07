{
  enabled = attributes: attributes // {
    enable = true;
  };

  normalUser = attributes: attributes // {
    isNormalUser = true;
  };

  systemUser = attributes: attributes // {
    isSystemUser = true;
  };

  graphicalUser = attributes: attributes // {
    isNormalUser = true;
    extraGroups  = [ "graphical" ] ++ attributes.extraGroups or []; 
  };
}
