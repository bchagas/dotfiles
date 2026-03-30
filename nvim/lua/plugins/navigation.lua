return {
  -- Shared utility library
  { "nvim-lua/plenary.nvim", lazy = true },

  -- Telescope (replaces fzf + CtrlP)
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function() return vim.fn.executable("make") == 1 end,
      },
    },
    config = function()
      local telescope = require("telescope")
      local actions   = require("telescope.actions")

      telescope.setup({
        defaults = {
          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<Esc>"] = actions.close,
            },
          },
          file_ignore_patterns = {
            "node_modules", ".git/", "%.lock", "dist/", "build/",
          },
          layout_strategy = "horizontal",
          layout_config    = { preview_width = 0.55 },
          path_display     = { "truncate" },
        },
        pickers = {
          find_files = { hidden = true },
        },
      })

      pcall(telescope.load_extension, "fzf")
    end,
  },
}
