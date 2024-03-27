lib: {
  enabled = lib.mkMerge [{
    enable = true;
  }] // {
    __functor = self: attributes: self // {
      contents = self.contents ++ [ attributes ];
    };
  };

  disabled = { enable = false; };
}
