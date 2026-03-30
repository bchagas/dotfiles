-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Must be set before plugins load
vim.g.mapleader = ","
vim.g.maplocalleader = ","

-- Load core config
require("config.options")
require("config.keymaps")
require("config.autocmds")

-- Load all plugins (auto-discovers lua/plugins/*.lua)
require("lazy").setup("plugins", {
  change_detection = { notify = false },
  checker = { enabled = true, notify = false },
  ui = { border = "rounded" },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip", "matchit", "matchparen", "netrwPlugin",
        "tarPlugin", "tohtml", "tutor", "zipPlugin",
      },
    },
  },
})
