lib: {
  mkConst = value: lib.mkOption {
    default  = value;
    readOnly = true;
  };

  mkValue = value: lib.mkOption {
    default = value;
  };
}
