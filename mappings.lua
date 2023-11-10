-- n, v, i, t = mode names

local M = {}

M.dap = {
  plugin = true,
  n = {
    ["<leader>db"] = {"<cmd> DapToggleBreakpoint <CR>"}
  }
}

M.dap_python = {
  plugin = true,
  n = {
    ["<leader>dpr"] = {
      function()
        require('dap-python').test_method()
      end
    }
  }
}

M.disabled = {
  n = {
    ["<A-h>"] = "",
    ["<C-h>"] = "",
    ["<C-l>"] = "",
    ["<C-j>"] = "",
    ["<C-k>"] = "",
    ["<C-s>"] = "",
    ["<C-c>"] = "",
    ["<C-n>"] = "",
  },
  
  i = {
    ["<C-b>"] = "",
    ["<C-e>"] = "",
    ["<C-h>"] = "",
    ["<C-l>"] = "",
    ["<C-j>"] = "",
    ["<C-k>"] = "",
  },
  
  t = {
    ["<A-h>"] = "",
    ["<C-x>"] = "",
  },
}

M.pinky_saver = {
  n = {
    -- switch between windows
    ["<A-h>"] = { "<C-w>h", "Window left" },
    ["<A-l>"] = { "<C-w>l", "Window right" },
    ["<A-j>"] = { "<C-w>j", "Window down" },
    ["<A-k>"] = { "<C-w>k", "Window up" },

    -- save
    ["<A-s>"] = { "<cmd> w <CR>", "Save file" },

    -- Copy all
    ["<A-c>"] = { "<cmd> %y+ <CR>", "Copy whole file" },
    
    -- toggle terminal in normal mode
    ["<A-t>"] = {
      function()
        require("nvterm.terminal").toggle "horizontal"
      end,
      "Toggle horizontal term",
    },
    
    -- toggle directory tree
    ["<A-n>"] = { "<cmd> NvimTreeToggle <CR>", "Toggle nvimtree" },
  },

  i = {
    -- go to  beginning and end
    ["<A-b>"] = { "<ESC>^i", "Beginning of line" },
    ["<A-e>"] = { "<End>", "End of line" },

    -- navigate within insert mode
    ["<A-h>"] = { "<Left>", "Move left" },
    ["<A-l>"] = { "<Right>", "Move right" },
    ["<A-j>"] = { "<Down>", "Move down" },
    ["<A-k>"] = { "<Up>", "Move up" },
  },
  
  t = {
    ["<A-x>"] = { vim.api.nvim_replace_termcodes("<C-\\><C-N>", true, true, true), "Escape terminal mode" },
    
    -- toggle in terminal mode
    ["<A-t>"] = {
      function()
        require("nvterm.terminal").toggle "horizontal"
      end,
      "Toggle horizontal term",
    },
  },
}
return M
