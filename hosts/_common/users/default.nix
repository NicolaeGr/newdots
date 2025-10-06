{ ... }:
{
  imports = [
    ./nicolae
    ./victor
    ./deploy
    ./adrian
    # ./guest
  ];

  users.nicolae.enable = true;

  users.mutableUsers = false;
}
