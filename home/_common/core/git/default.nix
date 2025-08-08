{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;

    extraConfig = {
      log.showSignature = "true";
      init.defaultBranch = "main";
      pull.rebase = "true";
      # url = {
      #   "ssh://git@github.com" = {
      #     insteadOf = "https://github.com";
      #   };
      #   "ssh://git@gitlab.com" = {
      #     insteadOf = "https://gitlab.com";
      #   };
      # };
    };

    # commit.gpgsign = true;
    # gpg.format = "ssh";
    # gpg.ssh.allowedSignersFile = "${config.home.homeDirectory}/.ssh/allowed_signers";

    ignores = [
      ".csvignore"
      ".direnv"
      "result"
    ];
  };
}
