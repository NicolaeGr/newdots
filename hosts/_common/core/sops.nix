{ configLib, inputs, ... }:
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  sops = {
    defaultSopsFile = (configLib.relativeToRoot "secrets/secrets.yaml");
    defaultSopsFormat = "yaml";

    age = {
      generateKey = true;
      keyFile = "/var/lib/sops-nix/key.txt";
      sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    };

    secrets = {
      "passwords/nicolae" = {
        neededForUsers = true;
      };
    };
  };
}
