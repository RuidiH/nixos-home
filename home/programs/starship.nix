{ ... }:
{
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      line_break.disabled = true;

      palette = "nord";
      palettes.nord = {
        nord0 = "#2E3440";
        nord1 = "#3B4252";
        nord2 = "#434C5E";
        nord3 = "#4C566A";
        nord4 = "#D8DEE9";
        nord5 = "#E5E9F0";
        nord6 = "#ECEFF4";
        nord7 = "#8FBCBB";
        nord8 = "#88C0D0";
        nord9 = "#81A1C1";
        nord10 = "#5E81AC";
        nord11 = "#BF616A";
        nord12 = "#D08770";
        nord13 = "#EBCB8B";
        nord14 = "#A3BE8C";
        nord15 = "#B48EAD";
      };

      format = "$directory$git_branch$python$nix_shell$aws$line_break$character";

      directory = {
        truncation_length = 1;
        truncate_to_repo = true;
        style = "bold nord8";
      };

      git_branch = {
        format = " [$branch]($style) ";
        style = "bold nord14";
      };

      python.format = "[ ](nord13) ";

      nix_shell.format = "[ ](nord10) ";

      aws.format = "[ ](nord13) ";

      character = {
        success_symbol = "[❯](bold nord14)";
        error_symbol = "[❯](bold nord11)";
        vimcmd_symbol = "[❮](bold nord15)";
      };

      cmd_duration.disabled = true;
    };
  };
}
