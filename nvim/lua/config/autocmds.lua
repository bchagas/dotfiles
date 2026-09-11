local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Strip trailing whitespace on save (from vimrc)
augroup("StripWhitespace", { clear = true })
autocmd("BufWritePre", {
  group = "StripWhitespace",
  pattern = "*",
  callback = function()
    local pos = vim.api.nvim_win_get_cursor(0)
    vim.cmd([[%s/\s\+$//e]])
    vim.api.nvim_win_set_cursor(0, pos)
  end,
})

-- Highlight on yank
augroup("YankHighlight", { clear = true })
autocmd("TextYankPost", {
  group = "YankHighlight",
  callback = function()
    vim.hl.on_yank({ higroup = "IncSearch", timeout = 150 })
  end,
})

-- Python: 4-space indent (from vimrc)
augroup("FileTypeOverrides", { clear = true })
autocmd("FileType", {
  group = "FileTypeOverrides",
  pattern = "python",
  callback = function()
    vim.bo.softtabstop = 4
    vim.bo.shiftwidth = 4
  end,
})

-- Close certain windows with q
augroup("QuickClose", { clear = true })
autocmd("FileType", {
  group = "QuickClose",
  pattern = { "help", "qf", "lspinfo", "startuptime", "checkhealth", "lazy" },
  callback = function()
    vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = true, silent = true })
  end,
})

-- Auto-resize splits on window resize
augroup("AutoResize", { clear = true })
autocmd("VimResized", {
  group = "AutoResize",
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})
