{
  lib,
  inputs,
  pkgs,
  ...
}:
{
  imports = [ inputs.stylix.homeModules.stylix ];

  stylix = {
    enable = true;
    autoEnable = true;
    polarity = "dark";

    icons = {
      enable = true;
      dark = "kora";
      light = "kora";
      package = pkgs.kora-icon-theme;
    };

    cursor = {
      name = "hyprcursor-rose-pine";
      package = inputs.rose-pine-hyprcursor.packages.${pkgs.system}.default;
      size = 24;
    };

    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";

    targets.qt.enable = true;
    targets.vscode.enable = lib.mkDefault false;
    targets.firefox.enable = true;
    targets.firefox.colorTheme.enable = true;
    targets.firefox.profileNames = [ "firefox.default" ];
  };
}
