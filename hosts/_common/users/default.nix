{ ... }:
{
  imports = [
    ./nicolae
    # ./victor
    # ./guest
  ];
  users.nicolae.enable = true;

  # users.mutableUsers = false;
}
