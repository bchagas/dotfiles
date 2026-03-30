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
    },
  },

  -- File tree (replaces NERDTree)
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    opts = {
      sort_by = "case_sensitive",
      view = { width = 35 },
      renderer = {
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
