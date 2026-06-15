{ inputs, ... }:
{
  imports = [ inputs.nixvim.homeModules.nixvim ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;
   
    colorschemes.nord = {
      enable = true;
    };

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
      showmode = false;
    };

    globals.mapleader = " ";
    globals.maplocalleader = " ";

    extraConfigLua = ''
      vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        underlines = true,
        update_in_insert = false,
      })

      vim.filetype.add({
        pattern = {
          [".*/templates/.*%.yaml"] = "helm",
          [".*/templates/.*%.yml"] = "helm",
          [".*/templates/.*%.tpl"] = "helm",
          ["helmfile.*%.yaml"] = "helm",
        },
      })
    '';

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
        };
        servers = {
          nixd.enable = true;
          pyright.enable = true;
          gopls.enable = true;
          yamlls.enable = true;
          helm_ls.enable = true;
          dockerls.enable = true;
          clangd.enable = true;
        };

        # Auto-format on save
        onAttach = ''
          if client and client:supports_method("textDocument/formatting", bufnr) then
            local group = vim.api.nvim_create_augroup("lsp_format_" .. bufnr, { clear = true })

            vim.api.nvim_create_autocmd("BufWritePre", {
              group = group,
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format({
                  bufnr = bufnr,
                  timeout_ms = 3000,
                })
              end,
            })
          end
        '';
      };

      cmp = {
        enable = true;
        autoEnableSources = true;
        settings = {
          sources = [
            { name = "nvim_lsp"; }
            { name = "path"; }
          ];
          completion.completeopt = "menu,menuone,noinsert,noselect";
          preselect.__raw = "cmp.PreselectMode.None";
          mapping = {
            "<Tab>".__raw = "cmp.mapping.select_next_item()";
            "<S-Tab>".__raw = "cmp.mapping.select_prev_item()";
            "<CR>".__raw = ''
              cmp.mapping(function(fallback)
                if cmp.visible() and cmp.get_selected_entry() then
                  cmp.confirm({ select = false })
                else
                  fallback()
                end
              end, { "i", "s" })
            '';
            "<C-y>".__raw = "cmp.mapping.confirm({ select = true })";
            "<C-Space>".__raw = "cmp.mapping.complete()";
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
      fugitive.enable = true;
      bufferline.enable = true;
      lightline = {
        enable = true;
        settings = {
          colorscheme = "nord";
          enable = {
            statusline = 1;
            tabline = 0;
          };
          active = {
            left = [
              [ "mode" "paste" ]
              [ "gitbranch" "readonly" "filename" "modified" ]
            ];
          };
          component_function = {
            gitbranch = "FugitiveHead";
          };
        };
      };
      gitsigns.enable = true;
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
      { mode = "n"; key = "<leader>h"; action = "<cmd>wincmd h<CR>"; options = { desc = "Move to left split"; silent = true; }; }
      { mode = "n"; key = "<leader>j"; action = "<cmd>wincmd j<CR>"; options = { desc = "Move to lower split"; silent = true; }; }
      { mode = "n"; key = "<leader>k"; action = "<cmd>wincmd k<CR>"; options = { desc = "Move to upper split"; silent = true; }; }
      { mode = "n"; key = "<leader>l"; action = "<cmd>wincmd l<CR>"; options = { desc = "Move to right split"; silent = true; }; }
      { mode = "n"; key = "<leader>H"; action = "<cmd>vertical resize -5<CR>"; options = { desc = "Resize split left"; silent = true; }; }
      { mode = "n"; key = "<leader>J"; action = "<cmd>resize +5<CR>"; options = { desc = "Resize split down"; silent = true; }; }
      { mode = "n"; key = "<leader>K"; action = "<cmd>resize -5<CR>"; options = { desc = "Resize split up"; silent = true; }; }
      { mode = "n"; key = "<leader>L"; action = "<cmd>vertical resize +5<CR>"; options = { desc = "Resize split right"; silent = true; }; }
      { mode = "n"; key = "<leader>p"; action = "<cmd>vsplit<CR>"; options = { desc = "Vertical split"; silent = true; }; }
      { mode = "n"; key = "<leader>o"; action = "<cmd>split<CR>"; options = { desc = "Horizontal split"; silent = true; }; }
      { mode = "n"; key = "<leader>="; action = "<cmd>wincmd =<CR>"; options = { desc = "Equalize splits"; silent = true; }; }
      { mode = "n"; key = "]d"; action.__raw = "vim.diagnostic.goto_next"; options = { desc = "Next diagnostic"; silent = true; }; }
      { mode = "n"; key = "[d"; action.__raw = "vim.diagnostic.goto_prev"; options = { desc = "Prev diagnostic"; silent = true; }; }
      { mode = "n"; key = "<leader>d"; action.__raw = "vim.diagnostic.open_float"; options = { desc = "Line diagnostic"; silent = true; }; }
    ];
  };
}
