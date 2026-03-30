return {
  -- ── Copilot: ambient inline ghost-text completions ────────────────────────
  {
    "github/copilot.vim",
    event = "InsertEnter",
    init = function()
      -- Disable Tab (nvim-cmp owns Tab in insert mode)
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_assume_mapped = true
      vim.g.copilot_filetypes = {
        ["*"]            = true,
        gitcommit        = false,
        TelescopePrompt  = false,
      }
    end,
    config = function()
      -- Accept with Alt-l (no Tab conflict)
      vim.keymap.set("i", "<M-l>", 'copilot#Accept("")', {
        expr             = true,
        replace_keycodes = false,
        desc             = "Copilot: Accept suggestion",
      })
      vim.keymap.set("i", "<M-]>", "<Plug>(copilot-next)",     { desc = "Copilot: Next suggestion" })
      vim.keymap.set("i", "<M-[>", "<Plug>(copilot-previous)", { desc = "Copilot: Prev suggestion" })
      vim.keymap.set("i", "<M-\\>", "<Plug>(copilot-suggest)", { desc = "Copilot: Request suggestion" })
    end,
  },

  -- ── Avante: Claude chat panel (like Cursor, on-demand) ────────────────────
  {
    "yetone/avante.nvim",
    event   = "VeryLazy",
    version = false,
    build   = "make",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
      {
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts  = {
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name  = false,
            drag_and_drop         = { insert_mode = true },
            use_absolute_path     = true,
          },
        },
      },
      {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = { file_types = { "markdown", "Avante" } },
        ft   = { "markdown", "Avante" },
      },
    },
    opts = {
      -- Provider: Claude via Anthropic API
      -- Requires ANTHROPIC_API_KEY env var (set in ~/.zshenv)
      provider = "claude",
      claude = {
        endpoint    = "https://api.anthropic.com",
        model       = "claude-sonnet-4-6",
        timeout     = 30000,
        temperature = 0,
        max_tokens  = 8096,
      },

      behaviour = {
        -- copilot.vim handles ambient completions; avante is deliberate/on-demand
        auto_suggestions                 = false,
        auto_set_highlight_group         = true,
        auto_set_keymaps                 = true,
        auto_apply_diff_after_generation = false,
        support_paste_from_clipboard     = false,
      },

      windows = {
        position = "right",
        wrap     = true,
        width    = 40,
        sidebar_header = {
          align   = "center",
          rounded = true,
        },
      },

      mappings = {
        diff = {
          ours      = "co",
          theirs    = "ct",
          all_theirs = "ca",
          both      = "cb",
          cursor    = "cc",
          next      = "]x",
          prev      = "[x",
        },
        submit = {
          normal = "<CR>",
          insert = "<C-CR>",
        },
      },
    },
  },

  -- dressing.nvim: better vim.ui.input / vim.ui.select (used by avante)
  {
    "stevearc/dressing.nvim",
    lazy = true,
    opts = {},
  },
}
