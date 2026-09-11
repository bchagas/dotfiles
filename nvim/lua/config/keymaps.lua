local map = vim.keymap.set

-- Save (from vimrc: Ctrl-s)
map({ "n", "i" }, "<C-s>", "<cmd>w<CR>", { desc = "Save file" })

-- Tab navigation (from vimrc: Tab = gt, S-Tab = gT)
map("n", "<Tab>", "gt", { desc = "Next tab" })
map("n", "<S-Tab>", "gT", { desc = "Prev tab" })

-- Clear search highlight (from vimrc: ,/)
map("n", "<leader>/", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- Better window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to top window" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- File tree
map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file tree" })
map("n", "<leader>o", "<cmd>NvimTreeFocus<CR>", { desc = "Focus file tree" })

-- Telescope (replaces fzf + CtrlP from vimrc: ,t was CtrlP)
map("n", "<leader>t", "<cmd>Telescope find_files<CR>", { desc = "Find files" })
map("n", "<leader>f", "<cmd>Telescope live_grep<CR>", { desc = "Live grep" })
map("n", "<leader>bb", "<cmd>Telescope buffers<CR>", { desc = "List buffers" })
map("n", "<leader>h", "<cmd>Telescope help_tags<CR>", { desc = "Help tags" })
map("n", "<leader>gs", "<cmd>Telescope git_status<CR>", { desc = "Git status" })

-- Diagnostics
map("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, { desc = "Prev diagnostic" })
map("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end,  { desc = "Next diagnostic" })
map("n", "<leader>d", vim.diagnostic.open_float, { desc = "Show diagnostic" })

-- DAP (from vimrc conventions)
map("n", "<F5>",  "<cmd>lua require('dap').continue()<CR>",           { desc = "DAP: Continue" })
map("n", "<F10>", "<cmd>lua require('dap').step_over()<CR>",          { desc = "DAP: Step over" })
map("n", "<F11>", "<cmd>lua require('dap').step_into()<CR>",          { desc = "DAP: Step into" })
map("n", "<F12>", "<cmd>lua require('dap').step_out()<CR>",           { desc = "DAP: Step out" })
map("n", "<leader>db", "<cmd>lua require('dap').toggle_breakpoint()<CR>", { desc = "DAP: Toggle breakpoint" })
map("n", "<leader>du", "<cmd>lua require('dapui').toggle()<CR>",      { desc = "DAP: Toggle UI" })

-- Neotest (from vimrc: ,w ,s ,l)
map("n", "<leader>w", "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<CR>", { desc = "Test: Run file" })
map("n", "<leader>s", "<cmd>lua require('neotest').run.run()<CR>",                  { desc = "Test: Run nearest" })
map("n", "<leader>l", "<cmd>lua require('neotest').run.run_last()<CR>",             { desc = "Test: Run last" })
map("n", "<leader>to", "<cmd>lua require('neotest').output_panel.toggle()<CR>",     { desc = "Test: Toggle output" })

-- Git (fugitive)
map("n", "<leader>gg", "<cmd>Git<CR>",        { desc = "Git: Status" })
map("n", "<leader>gd", "<cmd>Gdiffsplit<CR>", { desc = "Git: Diff" })
map("n", "<leader>gb", "<cmd>Git blame<CR>",  { desc = "Git: Blame" })
map("n", "<leader>gl", "<cmd>Git log<CR>",    { desc = "Git: Log" })

-- Formatting (prettier via conform)
map({ "n", "v" }, "<leader>p", "<cmd>lua require('conform').format({ async = true })<CR>", { desc = "Format (prettier)" })

-- Trouble
map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>",         { desc = "Diagnostics (workspace)" })
map("n", "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", { desc = "Diagnostics (buffer)" })

-- AI: Claude Code (claudecode.nvim) uses <leader>a* — see plugins/ai.lua
-- Copilot accept: <M-l> (set in ai.lua)
