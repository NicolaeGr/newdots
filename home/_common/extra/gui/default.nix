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
    stylix.enable = true;
    stylix.autoEnable = true;
    stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    stylix.polarity = "dark";

    programs.vscode.enable = true;

    home.packages = with pkgs; [
      unstable.gnome-calculator
      unstable.nautilus
      unstable.cheese
      unstable.baobab
      unstable.loupe
    ];
  };
}
