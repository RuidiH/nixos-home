{ inputs, ... }:
{
  imports = [ inputs.nixvim.homeModules.nixvim ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    opts = {
      number = true;
      relativenumber = true;
      shiftwidth = 2;
      tabstop = 2;
      expandtab = true;
      smartindent = true;
      wrap = false;
      cursorline = true;
      scrolloff = 8;
      signcolumn = "yes";
      termguicolors = true;
      clipboard = "unnamedplus";
      ignorecase = true;
      smartcase = true;
      updatetime = 250;
    };

    globals.mapleader = " ";
    globals.maplocalleader = " ";

    diagnostics.virtual_lines = true;

    plugins = {
      treesitter = {
        enable = true;
        settings = {
          highlight.enable = true;
          indent.enable = true;
        };
      };

      lsp = {
        enable = true;
        inlayHints = true;
        keymaps = {
          lspBuf = {
            "K" = "hover";
            "gd" = "definition";
            "gD" = "references";
            "gi" = "implementation";
            "gt" = "type_definition";
            "<leader>rn" = "rename";
            "<leader>ca" = "code_action";
          };
          diagnostic = {
            "<leader>j" = "goto_next";
            "<leader>k" = "goto_prev";
          };
        };
        servers = {
          nixd.enable = true;
          pyright.enable = true;
          gopls.enable = true;
        };
      };

      cmp = {
        enable = true;
        autoEnableSources = true;
        settings = {
          sources = [
            { name = "nvim_lsp"; }
            { name = "path"; }
            { name = "buffer"; }
          ];
          mapping = {
            "<Tab>".__raw = "cmp.mapping.select_next_item()";
            "<S-Tab>".__raw = "cmp.mapping.select_prev_item()";
            "<CR>".__raw = "cmp.mapping.confirm({ select = true })";
            "<C-e>".__raw = "cmp.mapping.close()";
          };
        };
      };

      telescope = {
        enable = true;
        keymaps = {
          "<leader>ff" = "find_files";
          "<leader>fg" = "live_grep";
          "<leader>fb" = "buffers";
          "<leader>fh" = "help_tags";
          "<C-p>" = { action = "git_files"; options.desc = "Git files"; };
        };
      };


      render-markdown.enable = true;
      which-key.enable = true;
      lualine.enable = true;
      gitsigns.enable = true;
      bufferline.enable = true;
      nvim-autopairs.enable = true;
      web-devicons.enable = true;
      yazi.enable = true;
    };

    keymaps = [
      { mode = "n"; key = "<leader>y"; action = "<cmd>Yazi<CR>"; options = { desc = "Open yazi"; silent = true; }; }
      { mode = "n"; key = "<Esc>"; action = "<cmd>noh<CR>"; options = { desc = "Clear highlight"; silent = true; }; }
      { mode = "n"; key = "<leader>w"; action = "<cmd>w<CR>"; options = { desc = "Save"; silent = true; }; }
      { mode = "n"; key = "<leader>q"; action.__raw = ''
          function()
            if #vim.fn.getbufinfo({ buflisted = 1 }) > 1 then
              vim.cmd("bd")
            else
              vim.cmd("q")
            end
          end
        ''; options = { desc = "Close buffer or quit"; silent = true; }; }
      { mode = "n"; key = "<S-l>"; action = "<cmd>bnext<CR>"; options = { desc = "Next buffer"; silent = true; }; }
      { mode = "n"; key = "<S-h>"; action = "<cmd>bprevious<CR>"; options = { desc = "Previous buffer"; silent = true; }; }
    ];
  };
}
