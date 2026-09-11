return {
  -- Mason: install LSP servers, formatters, linters
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    opts = {
      ui = { border = "rounded" },
    },
  },

  -- Bridge between mason and lspconfig (v2: installed servers are enabled
  -- automatically via vim.lsp.enable)
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = {
        "ts_ls",    -- TypeScript / JavaScript
        "eslint",   -- ESLint language server
        "jsonls",   -- JSON
        "html",     -- HTML
        "cssls",    -- CSS
        "lua_ls",   -- Lua (editing this config)
      },
    },
  },

  -- Core LSP (Neovim 0.11+ native API: vim.lsp.config / vim.lsp.enable;
  -- nvim-lspconfig only provides the per-server defaults in lsp/*.lua)
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "b0o/schemastore.nvim",
    },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Keymaps + per-server tweaks, applied whenever a server attaches to a buffer
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspAttach", { clear = true }),
        callback = function(args)
          local bufnr = args.buf
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if not client then return end

          local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
          end
          map("gd",         vim.lsp.buf.definition,      "Go to definition")
          map("gD",         vim.lsp.buf.declaration,     "Go to declaration")
          map("gr",         vim.lsp.buf.references,      "Go to references")
          map("gi",         vim.lsp.buf.implementation,  "Go to implementation")
          map("K",          vim.lsp.buf.hover,           "Hover docs")
          map("<leader>rn", vim.lsp.buf.rename,          "Rename symbol")
          map("<leader>ca", vim.lsp.buf.code_action,     "Code action")
          map("<leader>ds", vim.lsp.buf.document_symbol, "Document symbols")

          -- TypeScript / JavaScript: conform owns formatting, not ts_ls
          if client.name == "ts_ls" then
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
          end

          -- ESLint: auto-fix on save (LspEslintFixAll is created by lsp/eslint.lua)
          if client.name == "eslint" then
            vim.api.nvim_create_autocmd("BufWritePre", {
              group = vim.api.nvim_create_augroup("EslintFixOnSave_" .. bufnr, { clear = true }),
              buffer = bufnr,
              command = "LspEslintFixAll",
            })
          end
        end,
      })

      -- Defaults for every server
      vim.lsp.config("*", { capabilities = capabilities })

      -- TypeScript / JavaScript
      vim.lsp.config("ts_ls", {
        settings = {
          typescript = {
            inlayHints = {
              includeInlayParameterNameHints = "all",
              includeInlayFunctionLikeReturnTypeHints = true,
            },
          },
          javascript = {
            inlayHints = {
              includeInlayParameterNameHints = "all",
            },
          },
        },
      })

      -- JSON with schema catalog
      vim.lsp.config("jsonls", {
        settings = {
          json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
          },
        },
      })

      -- Lua (for editing this config)
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = { globals = { "vim" } },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            telemetry = { enable = false },
          },
        },
      })

      -- eslint / cssls / html use the lsp/*.lua defaults as-is.
      -- No vim.lsp.enable() here: mason-lspconfig (automatic_enable, default in
      -- v2) enables every server installed through Mason, including the
      -- ensure_installed ones above, so nothing is enabled before it exists.

      -- Diagnostic display
      vim.diagnostic.config({
        virtual_text = { spacing = 4, prefix = "●" },
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = { border = "rounded", source = true },
      })
    end,
  },

  -- JSON schema catalog
  { "b0o/schemastore.nvim", lazy = true },
}
