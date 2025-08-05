{ ... }: {
  programs.git = {
    includes = [
      {
        condition = "gitdir:~/Projects/work/";

        contents = {
          user = {
            name = "GrNicolae";
            email = "170510723+GrNicolae@users.noreply.github.com";
          };
        };
      }
      {
        contents = {
          init.defaultBranch = "main";
          push = {
            default = "current";
            autoSetupRemote = true;
          };

          user = {
            name = "NicolaeGr";
            email = "114419701+NicolaeGr@users.noreply.github.com";
          };
        };
      }
    ];
  };
}
