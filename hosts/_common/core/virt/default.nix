{ pkgs, ... }: {
  virtualisation.docker.enable = true;

  environment.systemPackages = with pkgs; [
    podman-desktop
    docker
    docker-compose
  ];
}
