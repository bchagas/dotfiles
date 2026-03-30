return {
  -- vim-fugitive (from vimrc — direct port)
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "Gdiffsplit", "Gblame", "Glog" },
  },

  -- Gitsigns: inline hunks + blame (replaces gitv)
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add          = { text = "▎" },
        change       = { text = "▎" },
        delete       = { text = "" },
        topdelete    = { text = "" },
        changedelete = { text = "▎" },
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local map = function(mode, keys, func, desc)
          vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = "Git: " .. desc })
        end

        -- Hunk navigation
        map("n", "]h", gs.next_hunk, "Next hunk")
        map("n", "[h", gs.prev_hunk, "Prev hunk")

        -- Hunk actions
        map("n", "<leader>hs", gs.stage_hunk,                                       "Stage hunk")
        map("n", "<leader>hr", gs.reset_hunk,                                       "Reset hunk")
        map("n", "<leader>hu", gs.undo_stage_hunk,                                  "Undo stage hunk")
        map("n", "<leader>hp", gs.preview_hunk,                                     "Preview hunk")
        map("n", "<leader>hb", function() gs.blame_line({ full = true }) end,       "Blame line")
        map("n", "<leader>td", gs.toggle_deleted,                                   "Toggle deleted")
      end,
    },
  },
}
