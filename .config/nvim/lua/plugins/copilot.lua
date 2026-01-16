return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      "zbirenbaum/copilot.lua", -- uses LazyVim's existing Copilot
      "nvim-lua/plenary.nvim",
    },
    cmd = {
      "CopilotChat",
      "CopilotChatOpen",
      "CopilotChatExplain",
      "CopilotChatTests",
      "CopilotChatFix",
      "CopilotChatOptimize",
    },
    opts = {
      debug = false,
      temperature = 0.2,
      window = {
        layout = "horizontal", -- vertical | horizontal | float
        height = 0.3,
      },
    },
    keys = {
      { "<leader>cc", "<cmd>CopilotChatOpen<CR>", desc = "Open Copilot Chat" },
      { "<leader>ce", "<cmd>CopilotChatExplain<CR>", desc = "Explain Selection" },
      { "<leader>ct", "<cmd>CopilotChatTests<CR>", desc = "Generate Tests" },
      { "<leader>cf", "<cmd>CopilotChatFix<CR>", desc = "Fix Code" },
      { "<leader>co", "<cmd>CopilotChatOptimize<CR>", desc = "Optimize Code" },
    },
  },

  {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter", -- load when entering insert mode
    opts = {},
  },
}
