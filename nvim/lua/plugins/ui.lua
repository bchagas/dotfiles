return {
  -- Icons (shared dependency)
  { "nvim-tree/nvim-web-devicons", lazy = true },

  -- Colorscheme: nightfox / carbonfox (already in old vimrc)
  {
    "EdenEast/nightfox.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("nightfox").setup({
        options = {
          styles = {
            comments = "italic",
            keywords = "bold",
          },
        },
      })
      vim.cmd("colorscheme carbonfox")
    end,
  },

  -- Statusline (replaces vim-airline)
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme = "nightfox",
        component_separators = "|",
        section_separators = { left = "", right = "" },
        globalstatus = true,
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
      extensions = { "nvim-tree" },
    },
  },

  -- File tree (replaces NERDTree)
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    init = function()
      -- Hide the `~` end-of-buffer markers inside the tree window
      vim.api.nvim_create_autocmd("BufWinEnter", {
        pattern = "NvimTree_*",
        callback = function() vim.opt_local.fillchars:append({ eob = " " }) end,
      })

      -- netrw is disabled, so when nvim is started on a directory (e.g. `nvim .`)
      -- make it the cwd and open the tree as a sidebar next to an empty buffer,
      -- the same layout as <leader>e
      local dir = vim.fn.argv(0)
      if vim.fn.argc() ~= 1 or vim.fn.isdirectory(dir) == 0 then return end
      vim.api.nvim_create_autocmd("VimEnter", {
        once = true,
        nested = true,
        callback = function()
          vim.cmd.cd(dir)
          local dir_buf = vim.api.nvim_get_current_buf()
          vim.cmd.enew()
          vim.api.nvim_buf_delete(dir_buf, { force = true })
          require("nvim-tree.api").tree.open()
        end,
      })
    end,
    opts = {
      sort_by = "case_sensitive",
      view = { width = 35 },
      renderer = {
        root_folder_label = ":~",
        group_empty = true,
        highlight_git = true,
        icons = { show = { git = true } },
      },
      filters = {
        dotfiles = false,
        custom = { "^.git$", "node_modules", ".DS_Store" },
      },
      git = { enable = true, ignore = false },
      actions = {
        open_file = { quit_on_open = true },
      },
    },
  },

  -- Indent guides (replaces vim-indent-guides)
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    main = "ibl",
    opts = {
      indent = { char = "▏" },
      scope = { enabled = true },
      exclude = {
        filetypes = { "help", "NvimTree", "dashboard", "lazy", "mason" },
      },
    },
  },

  -- Which-key: show available keybindings
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      delay = 500,
    },
  },
}
