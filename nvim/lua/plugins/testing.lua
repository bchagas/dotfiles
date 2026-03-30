return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/nvim-nio",
      "haydenmeade/neotest-jest",
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-jest")({
            -- Use project-local jest if available
            jestCommand = function()
              local project_jest = vim.fn.getcwd() .. "/node_modules/.bin/jest"
              if vim.fn.executable(project_jest) == 1 then
                return project_jest
              end
              return "jest"
            end,
            env = { CI = "true" },
            cwd = function()
              return vim.fn.getcwd()
            end,
          }),
        },
        output         = { open_on_run = "short" },
        status         = { virtual_text = true },
        icons = {
          passed  = "",
          failed  = "",
          running = "",
          skipped = "",
          unknown = "",
        },
      })
    end,
  },
}
