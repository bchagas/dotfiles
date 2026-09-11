return {
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      local lint = require("lint")

      lint.linters_by_ft = {
        javascript      = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescript      = { "eslint_d" },
        typescriptreact = { "eslint_d" },
      }

      -- Only run linters whose executable is actually installed
      -- (otherwise nvim-lint raises "Error running eslint_d: ENOENT" on every event)
      local function available_linters()
        local names = lint.linters_by_ft[vim.bo.filetype] or {}
        return vim.tbl_filter(function(name)
          local linter = lint.linters[name]
          local cmd = linter and linter.cmd
          if type(cmd) == "function" then cmd = cmd() end -- e.g. eslint_d: ./node_modules/.bin/eslint_d or global
          return type(cmd) == "string" and vim.fn.executable(cmd) == 1
        end, names)
      end

      -- Run linting on relevant events
      local lint_augroup = vim.api.nvim_create_augroup("Lint", { clear = true })
      vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
        group    = lint_augroup,
        callback = function()
          local names = available_linters()
          if #names > 0 then
            lint.try_lint(names)
          end
        end,
      })
    end,
  },
}
