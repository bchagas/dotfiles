return {
  -- vim-surround (from vimrc — direct port)
  { "tpope/vim-surround" },

  -- vim-repeat (from vimrc — makes surround repeatable with .)
  { "tpope/vim-repeat" },

  -- Autopairs (replaces delimitMate)
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      local autopairs = require("nvim-autopairs")
      autopairs.setup({
        check_ts = true,
        ts_config = {
          javascript = { "string", "template_string" },
          typescript = { "string", "template_string" },
        },
      })
      -- Hook into nvim-cmp
      local ok, cmp = pcall(require, "cmp")
      if ok then
        local cmp_autopairs = require("nvim-autopairs.completion.cmp")
        cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
      end
    end,
  },

  -- Emmet (from vimrc — JSX/TSX support)
  {
    "mattn/emmet-vim",
    ft = { "html", "css", "javascriptreact", "typescriptreact" },
    init = function()
      vim.g.user_emmet_leader_key = "<C-e>"
      vim.g.user_emmet_settings = {
        javascript = { extends = "jsx" },
        typescript = { extends = "tsx" },
      }
    end,
  },

  -- Comment.nvim (replaces NERDCommenter)
  -- Handles JSX/TSX comments correctly with ts-context-commentstring
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
    config = function()
      require("Comment").setup({
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
      })
    end,
  },

  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    lazy = true,
    init = function()
      -- No legacy nvim-treesitter module (removed in nvim-treesitter main)
      vim.g.skip_ts_context_commentstring_module = true
    end,
    opts = { enable_autocmd = false },
  },

  -- Trouble: better diagnostics list
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = "Trouble",
    opts = { use_diagnostic_signs = true },
  },

  -- vim-easy-align (from vimrc)
  {
    "junegunn/vim-easy-align",
    keys = {
      { "ga", "<Plug>(EasyAlign)", mode = { "n", "x" }, desc = "Easy align" },
    },
  },
}
