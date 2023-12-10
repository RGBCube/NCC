{
  importModules = modules: {
    imports = builtins.map (module: if builtins.isPath module then
      module
    else
      ../modules/${module}) modules;
  };
}
