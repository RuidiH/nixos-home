{ ... }:
{
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      line_break.disabled = true;

      format = "$directory$git_branch$python$nix_shell$aws$line_break$character";

      directory = {
        truncation_length = 1;
        truncate_to_repo = true;
      };

      git_branch.format = " [$branch]($style) ";

      python.format = "[🐍](yellow) ";

      nix_shell.format = "[❄️](blue) ";

      aws.format = "[☁️](yellow) ";

      cmd_duration.disabled = true;
    };
  };
}
