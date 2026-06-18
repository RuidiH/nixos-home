{ inputs, ... }:
{
  imports = [ inputs.nixvim.homeModules.nixvim ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;
   
    colorschemes.nord = {
      enable = true;
    };

    highlight = {
      LspInlayHint = {
        fg = "#6f7787";
        italic = true;
      };
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

      vim.api.nvim_create_user_command("SmartDeleteBuffer", function()
        local buf = vim.api.nvim_get_current_buf()

        if vim.bo[buf].modified then
          vim.notify("Buffer has unsaved changes", vim.log.levels.WARN)
          return
        end

        local listed = vim.tbl_filter(function(b)
          return b.bufnr ~= buf and b.listed == 1 and b.loaded == 1
        end, vim.fn.getbufinfo({ buflisted = 1 }))

        local target = nil
        local alt = vim.fn.bufnr("#")

        if alt > 0 and alt ~= buf and vim.fn.buflisted(alt) == 1 and vim.api.nvim_buf_is_loaded(alt) then
          target = alt
        elseif #listed > 0 then
          target = listed[1].bufnr
        elseif #vim.api.nvim_tabpage_list_wins(0) > 1 then
          target = vim.api.nvim_create_buf(true, false)
        else
          vim.cmd("quit")
          return
        end

        for _, win in ipairs(vim.fn.win_findbuf(buf)) do
          if vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_win_set_buf(win, target)
          end
        end

        local ok, err = pcall(vim.api.nvim_buf_delete, buf, {})
        if not ok then
          vim.notify(err, vim.log.levels.ERROR)
        end
      end, {})
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
      nvim-autopairs.enable = false;
      web-devicons.enable = true;
      yazi.enable = true;
    };

    keymaps = [
      { mode = "n"; key = "<leader>y"; action = "<cmd>Yazi<CR>"; options = { desc = "Open yazi"; silent = true; }; }
      { mode = "n"; key = "<Esc>"; action = "<cmd>noh<CR>"; options = { desc = "Clear highlight"; silent = true; }; }
      { mode = "n"; key = "<leader>w"; action = "<cmd>w<CR>"; options = { desc = "Save"; silent = true; }; }
      { mode = "n"; key = "<leader>q"; action = "<cmd>SmartDeleteBuffer<CR>"; options = { desc = "Close buffer"; silent = true; }; }
      { mode = "n"; key = "<leader>Q"; action = "<cmd>close<CR>"; options = { desc = "Close split"; silent = true; }; }
      { mode = "n"; key = "<S-l>"; action = "<cmd>bnext<CR>"; options = { desc = "Next buffer"; silent = true; }; }
      { mode = "n"; key = "<S-h>"; action = "<cmd>bprevious<CR>"; options = { desc = "Previous buffer"; silent = true; }; }
      { mode = "n"; key = "<leader>j"; action.__raw = "vim.diagnostic.goto_next"; options = { desc = "Next diagnostic"; silent = true; }; }
      { mode = "n"; key = "<leader>k"; action.__raw = "vim.diagnostic.goto_prev"; options = { desc = "Prev diagnostic"; silent = true; }; }
      {
        mode = "n";
        key = "<leader>uh";
        action.__raw = ''
          function()
            local bufnr = vim.api.nvim_get_current_buf()
            vim.lsp.inlay_hint.enable(
              not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }),
              { bufnr = bufnr }
            )
          end
        '';
        options.desc = "Toggle inlay hints";
      }
    ];
  };
}
