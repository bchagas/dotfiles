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

  -- ── Claude Code: IDE integration (runs the `claude` CLI in a split) ─────
  -- Signs in with your Claude subscription through Claude Code itself; no API key.
  -- Claude sees the current file/selection and proposes edits as native diffs.
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    config = true,
    -- Command stubs so :ClaudeCode* work before any <leader>a* key is pressed
    cmd = {
      "ClaudeCode",
      "ClaudeCodeFocus",
      "ClaudeCodeSelectModel",
      "ClaudeCodeAdd",
      "ClaudeCodeSend",
      "ClaudeCodeTreeAdd",
      "ClaudeCodeStatus",
      "ClaudeCodeStart",
      "ClaudeCodeStop",
      "ClaudeCodeOpen",
      "ClaudeCodeClose",
      "ClaudeCodeDiffAccept",
      "ClaudeCodeDiffDeny",
      "ClaudeCodeCloseAllDiffs",
    },
    keys = {
      { "<leader>a",  nil,                              desc = "AI/Claude Code" },
      { "<leader>ac", "<cmd>ClaudeCode<cr>",            desc = "Toggle Claude" },
      { "<leader>af", "<cmd>ClaudeCodeFocus<cr>",       desc = "Focus Claude" },
      { "<leader>ar", "<cmd>ClaudeCode --resume<cr>",   desc = "Resume Claude" },
      { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
      { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
      { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>",       desc = "Add current buffer" },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>",        mode = "v", desc = "Send to Claude" },
      {
        "<leader>as",
        "<cmd>ClaudeCodeTreeAdd<cr>",
        desc = "Add file",
        ft   = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw", "snacks_picker_list" },
      },
      -- Diff management
      { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>",  desc = "Accept diff" },
      { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>",    desc = "Deny diff" },
    },
  },

  -- render-markdown: rendered headings/lists/code blocks in markdown buffers
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft   = { "markdown" },
    opts = { file_types = { "markdown" } },
  },
}
