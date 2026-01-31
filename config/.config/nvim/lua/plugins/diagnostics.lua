return {
  {
    "neovim/nvim-lspconfig",
    opts = function()
      -- Configure diagnostic display
      vim.diagnostic.config({
        virtual_text = {
          -- Limit virtual text to prevent overflow
          format = function(diagnostic)
            local max_width = 60
            local message = diagnostic.message
            if #message > max_width then
              return message:sub(1, max_width) .. "..."
            end
            return message
          end,
          -- Show source in virtual text
          source = "if_many",
          -- Add prefix icon based on severity
          prefix = "●",
        },
        -- Show full diagnostic in floating window
        float = {
          border = "rounded",
          source = "always",
          header = "",
          prefix = "",
          -- Allow wrapping in float
          wrap = true,
          max_width = 80,
          focusable = true,
        },
        -- Show signs in the sign column
        signs = true,
        -- Update diagnostics while typing
        update_in_insert = false,
        -- Sort by severity
        severity_sort = true,
      })

      -- Auto-show diagnostics in floating window when cursor holds
      vim.api.nvim_create_autocmd("CursorHold", {
        pattern = "*",
        callback = function()
          local opts = {
            focusable = false,
            close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
            border = "rounded",
            source = "always",
            prefix = " ",
            scope = "cursor",
          }
          vim.diagnostic.open_float(nil, opts)
        end,
      })

      -- Set updatetime for CursorHold (default is 4000ms which is too slow)
      vim.opt.updatetime = 500
    end,
  },
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = {
        { "<leader>cd", vim.diagnostic.open_float, desc = "Line Diagnostics" },
      },
    },
  },
}
