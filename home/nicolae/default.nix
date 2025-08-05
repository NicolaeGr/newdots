{ configLib, ... }:
{
  imports =
    [ ./config ]
    ++ (map configLib.relativeToRoot [
      "home/_common/core"
      "home/_common/extra"
    ]);

  config = {
    home = {
      username = "nicolae";
      homeDirectory = "/home/nicolae";
    };
  };
}
