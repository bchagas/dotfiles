-- nvim-treesitter `main` branch (rewrite, requires Neovim 0.12+):
-- no more `nvim-treesitter.configs`, modules or ensure_installed. Parsers are
-- installed with require("nvim-treesitter").install() and highlighting /
-- indentation are enabled per buffer with the built-in vim.treesitter API.
local parsers = {
  "javascript",
  "typescript",
  "tsx",
  "json", -- also used for jsonc
  "css",
  "html",
  "markdown",
  "markdown_inline",
  "lua",
  "bash",
  "yaml",
  "regex",
  "vim",
  "vimdoc",
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false, -- the main branch does not support lazy-loading
    build = ":TSUpdate",
    dependencies = {
      { "nvim-treesitter/nvim-treesitter-textobjects", branch = "main" },
    },
    config = function()
      -- Installs missing parsers (async, no-op for the ones already installed)
      require("nvim-treesitter").install(parsers)

      -- Highlight + indent for every buffer whose filetype has a parser
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("UserTreesitter", { clear = true }),
        callback = function(args)
          local buf = args.buf
          local lang = vim.treesitter.language.get_lang(args.match)
          if not lang then return end

          -- Disable for very large files
          local max_filesize = 100 * 1024
          local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then return end

          -- vim.treesitter.start errors when the parser is not installed
          if pcall(vim.treesitter.start, buf, lang) then
            vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })

      -- Text objects
      require("nvim-treesitter-textobjects").setup({
        select = { lookahead = true },
        move = { set_jumps = true },
      })

      local function select(query)
        return function()
          require("nvim-treesitter-textobjects.select").select_textobject(query, "textobjects")
        end
      end
      vim.keymap.set({ "x", "o" }, "af", select("@function.outer"), { desc = "Select outer function" })
      vim.keymap.set({ "x", "o" }, "if", select("@function.inner"), { desc = "Select inner function" })
      vim.keymap.set({ "x", "o" }, "ac", select("@class.outer"),    { desc = "Select outer class" })
      vim.keymap.set({ "x", "o" }, "ic", select("@class.inner"),    { desc = "Select inner class" })

      local function move(direction, query)
        return function()
          require("nvim-treesitter-textobjects.move")[direction](query, "textobjects")
        end
      end
      vim.keymap.set({ "n", "x", "o" }, "]f", move("goto_next_start",     "@function.outer"), { desc = "Next function start" })
      vim.keymap.set({ "n", "x", "o" }, "]c", move("goto_next_start",     "@class.outer"),    { desc = "Next class start" })
      vim.keymap.set({ "n", "x", "o" }, "[f", move("goto_previous_start", "@function.outer"), { desc = "Prev function start" })
      vim.keymap.set({ "n", "x", "o" }, "[c", move("goto_previous_start", "@class.outer"),    { desc = "Prev class start" })
    end,
  },
}
