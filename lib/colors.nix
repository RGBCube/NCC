_: self: _: {
  luminance = hex: let
    r = self.substring 0 2 hex |> self.fromHexString;
    g = self.substring 2 4 hex |> self.fromHexString;
    b = self.substring 4 6 hex |> self.fromHexString;
  in assert !self.hasPrefix "#" hex;
    0.2126 * r +
    0.7152 * g +
    0.0722 * b ;

  isDark  = { base00, base07, ... }: self.luminance base00 < self.luminance base07;
  isLight =                   theme: !self.isDark theme;
}
