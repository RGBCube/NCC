lib:

rec {
  merge = lib.recursiveUpdate;
  merge3 = x: y: merge (merge x y);
  merge4 = x: y: merge3 (merge x y);
  merge5 = x: y: merge4 (merge x y);
}
