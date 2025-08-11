{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Nix Essentials
    nixfmt
    nil
    nixpkgs-fmt

    # Utils
    lshw
    fastfetch
    jq
    tree
    wget
    curl
    unzip
    zip
    gzip
    bzip2
    xz
    gnutar
    rsync
    htop
    btop
    glances
    nethogs
  ];
}
