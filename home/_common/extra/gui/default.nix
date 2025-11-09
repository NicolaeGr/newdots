{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [ inputs.stylix.homeModules.stylix ];

  options.extra.gui.enable = lib.mkEnableOption {
    default = true;
    description = "Enable GUI features";
  };

  config = lib.mkIf config.extra.gui.enable {
    fonts.fontconfig.enable = true;

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
    };

    home.packages = with pkgs; [
      unstable.gnome-calculator
      unstable.nautilus
      unstable.cheese
      unstable.baobab
      unstable.loupe
      kora-icon-theme
      # inputs.rose-pine-hyprcursor.packages.${pkgs.system}.default
    ];
  };
}
