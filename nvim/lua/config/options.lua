local opt = vim.opt

-- Encoding
opt.encoding = "utf-8"
opt.fileencoding = "utf-8"

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Indentation (2-space, from vimrc)
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true

-- Searching
opt.hlsearch = true
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true

-- Visual
opt.termguicolors = true
opt.colorcolumn = "81"
opt.cursorline = true
opt.scrolloff = 5
opt.signcolumn = "yes"
opt.wrap = false
opt.showmode = false        -- lualine shows mode
opt.laststatus = 3          -- global statusline (nvim 0.7+)
opt.showbreak = ""

-- Splits
opt.splitbelow = true
opt.splitright = true

-- Performance / feel
opt.updatetime = 250
opt.timeoutlen = 300
opt.shortmess:append("c")

-- Files
opt.backup = false
opt.writebackup = false
opt.swapfile = false
opt.undofile = true         -- persistent undo
opt.history = 1000

-- Folding (treesitter-based)
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldlevel = 1
opt.foldnestmax = 10

-- Clipboard (from vimrc)
opt.clipboard = "unnamedplus"

-- Mouse (from vimrc)
opt.mouse = "nv"

-- Completion
opt.completeopt = { "menu", "menuone", "noselect" }

-- Misc
opt.ruler = true
opt.linespace = 0
opt.t_Co = "256"
