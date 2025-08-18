{ ... }:
{
  imports = [
    ./nicolae
    ./victor
    ./deploy
    # ./guest
  ];

  users.nicolae.enable = true;

  users.mutableUsers = false;
}
