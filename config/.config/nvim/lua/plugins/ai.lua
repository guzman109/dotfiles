return {
  {
    "olimorris/codecompanion.nvim",
    -- branch = "develop",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("codecompanion").setup({
        adapters = {
          acp = {
            claude_code = function()
              return require("codecompanion.adapters").extend("claude_code", {
                env = {
                  CLAUDE_CODE_OAUTH_TOKEN = vim.env.CLAUDE_CODE_OAUTH_TOKEN,
                },
              })
            end,
            codex = function()
              return require("codecompanion.adapters").extend("codex", {
                defaults = {
                  auth_method = "chatgpt", -- "openai-api-key"|"codex-api-key"|"chatgpt"
                },
              })
            end,
            gemini_cli = function()
              return require("codecompanion.adapters").extend("gemini_cli", {
                defaults = {
                  auth_method = "oauth-personal", -- "oauth-personal"|"gemini-api-key"|"vertex-ai"
                },
              })
            end,
          },
        },
        interactions = {
          chat = { adapter = "claude_code" },
          inline = { adapter = "claude_code" },
          cmd = { adapter = "claude_code" },
        },
        mcp = {
          servers = {
            ["bear-notes"] = {
              cmd = { "npx", "-y", "bear-notes-mcp@latest" },
              enabled = true,
            },
          },
          default_servers = { "bear-notes" },
        },
      })

      -- Command abbreviation: cc → CodeCompanion
      vim.cmd([[cab cc CodeCompanion]])

      -- Global keymaps
      vim.keymap.set("n", "<C-a>", "<cmd>CodeCompanionActions<cr>", { desc = "CodeCompanion Actions" })
      vim.keymap.set({ "n", "v" }, "<LocalLeader>a", "<cmd>CodeCompanionChat Toggle<cr>", { desc = "Toggle Chat" })
      vim.keymap.set("v", "ga", "<cmd>CodeCompanionChat Add<cr>", { desc = "Add Selection to Chat" })

      -- <leader>a keymaps (claudecode.nvim-compatible)
      vim.keymap.set({ "n", "v" }, "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", { desc = "Toggle Chat" })
      vim.keymap.set("n", "<leader>af", "<cmd>CodeCompanionChat<cr>", { desc = "Focus Chat" })
      vim.keymap.set("n", "<leader>ab", function()
        local cursor = vim.api.nvim_win_get_cursor(0)
        vim.cmd("normal! ggVG")
        vim.cmd("'<,'>CodeCompanionChat Add")
        vim.api.nvim_win_set_cursor(0, cursor)
      end, { desc = "Add Buffer to Chat" })
      vim.keymap.set("v", "<leader>as", "<cmd>CodeCompanionChat Add<cr>", { desc = "Add Selection to Chat" })
      vim.keymap.set("n", "<leader>aa", function()
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("gda", true, false, true), "m", false)
      end, { desc = "Accept Diff" })
      vim.keymap.set("n", "<leader>ad", function()
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("gdr", true, false, true), "m", false)
      end, { desc = "Reject Diff" })

      -- which-key group label
      require("which-key").add({ { "<leader>a", group = "AI/Claude" } })
    end,
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    optional = true,
    opts = {
      file_types = { "markdown", "codecompanion" },
    },
    ft = { "markdown", "codecompanion" },
  },
  {
    "saghen/blink.cmp",
    optional = true,
    opts = {
      sources = {
        per_filetype = {
          codecompanion = { "codecompanion" },
        },
      },
    },
  },
}
