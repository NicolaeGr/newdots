{ configLib, ... }:
{
  imports =
    [ ]
    ++ (map configLib.relativeToRoot [
      "home/_common/core"
      "home/_common/extra"
    ]);

  config = { };
}
