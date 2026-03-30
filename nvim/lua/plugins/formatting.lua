return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    cmd   = "ConformInfo",
    opts = {
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
        lsp_fallback = true,
      },
      formatters = {
        prettier = {
          -- Only run if the project has a prettier config
          require_cwd = true,
          cwd = require("conform.util").root_file({
            ".prettierrc",
            ".prettierrc.json",
            ".prettierrc.js",
            ".prettierrc.cjs",
            "prettier.config.js",
            "package.json",
          }),
        },
      },
    },
  },
}
