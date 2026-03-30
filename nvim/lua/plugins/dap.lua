return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      -- DAP UI
      {
        "rcarriga/nvim-dap-ui",
        dependencies = { "nvim-neotest/nvim-nio" },
        config = function()
          local dap, dapui = require("dap"), require("dapui")

          dapui.setup({
            layouts = {
              {
                elements = {
                  { id = "scopes",      size = 0.4 },
                  { id = "breakpoints", size = 0.2 },
                  { id = "stacks",      size = 0.2 },
                  { id = "watches",     size = 0.2 },
                },
                position = "left",
                size = 40,
              },
              {
                elements = {
                  { id = "repl",    size = 0.5 },
                  { id = "console", size = 0.5 },
                },
                position = "bottom",
                size = 12,
              },
            },
          })

          -- Auto open/close UI with DAP session
          dap.listeners.after.event_initialized["dapui_config"]  = dapui.open
          dap.listeners.before.event_terminated["dapui_config"]  = dapui.close
          dap.listeners.before.event_exited["dapui_config"]      = dapui.close
        end,
      },
      -- Mason integration for DAP adapters
      {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = { "williamboman/mason.nvim" },
        opts = {
          ensure_installed = { "js" },
          handlers = {},
        },
      },
    },
    config = function()
      local dap = require("dap")

      -- js-debug-adapter (installed via mason)
      local js_debug_path = vim.fn.stdpath("data")
        .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js"

      dap.adapters["pwa-node"] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = "node",
          args    = { js_debug_path, "${port}" },
        },
      }

      dap.adapters["pwa-chrome"] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = "node",
          args    = { js_debug_path, "${port}" },
        },
      }

      -- Debug configs for all JS/TS filetypes
      for _, lang in ipairs({
        "typescript", "javascript", "typescriptreact", "javascriptreact"
      }) do
        dap.configurations[lang] = {
          {
            type    = "pwa-node",
            request = "launch",
            name    = "Launch file (Node)",
            program = "${file}",
            cwd     = "${workspaceFolder}",
          },
          {
            type      = "pwa-node",
            request   = "attach",
            name      = "Attach to process",
            processId = require("dap.utils").pick_process,
            cwd       = "${workspaceFolder}",
          },
          {
            type    = "pwa-chrome",
            request = "launch",
            name    = "Launch Chrome",
            url     = "http://localhost:3000",
            webRoot = "${workspaceFolder}",
          },
        }
      end
    end,
  },
}
