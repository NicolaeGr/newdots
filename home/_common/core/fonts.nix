{ pkgs, ... }:
{
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji

    font-awesome
    nerd-fonts.jetbrains-mono
  ];

  stylix.fonts = {
    emoji = {
      name = "Noto Emoji";
      package = pkgs.noto-fonts-emoji;
    };

    monospace = {
      name = "JetBrains Mono Nerd Font";
      package = pkgs.nerd-fonts.jetbrains-mono;
    };

    sansSerif = {
      name = "Noto Sans";
      package = pkgs.noto-fonts;
    };

    serif = {
      name = "Noto Serif";
      package = pkgs.noto-fonts;
    };
  };
}
