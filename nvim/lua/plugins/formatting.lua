return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    cmd   = "ConformInfo",
    -- opts as a function: conform is only on the runtimepath once the plugin
    -- loads, so require("conform.util") must not run at spec-parse time.
    opts = function()
      local util = require("conform.util")
      return {
        formatters_by_ft = {
          javascript      = { "prettier" },
          javascriptreact = { "prettier" },
          typescript      = { "prettier" },
          typescriptreact = { "prettier" },
          json            = { "prettier" },
          jsonc           = { "prettier" },
          css             = { "prettier" },
          html            = { "prettier" },
          markdown        = { "prettier" },
          yaml            = { "prettier" },
        },
        format_on_save = {
          timeout_ms   = 2000,
          lsp_format   = "fallback",
        },
        formatters = {
          prettier = {
            -- Only run if the project has a prettier config
            require_cwd = true,
            cwd = util.root_file({
              ".prettierrc",
              ".prettierrc.json",
              ".prettierrc.js",
              ".prettierrc.cjs",
              "prettier.config.js",
              "package.json",
            }),
          },
        },
      }
    end,
  },
}
