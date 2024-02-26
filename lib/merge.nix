lib: let
  mergeAll = builtins.foldl' (collected: module: {
    imports = collected.imports ++ [ module ];
  }) { imports = []; };
in {
  merge  = a: b: mergeAll [ a b  ];
  merge3 = a: b: c: mergeAll [ a b c  ];
  merge4 = a: b: c: d: mergeAll [ a b c d ];
  merge5 = a: b: c: d: e: mergeAll [ a b c d e ];
  merge6 = a: b: c: d: e: f: mergeAll [ a b c d e f ];

  recursiveUpdateAll = builtins.foldl' lib.recursiveUpdate {};
}
