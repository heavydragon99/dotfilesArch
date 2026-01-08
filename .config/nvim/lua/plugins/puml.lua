return {
  {
    "https://gitlab.com/itaranto/plantuml.nvim",
    version = "*",
    lazy = true, -- lazy load
    ft = { "plantuml", "puml" }, -- only load for these filetypes
    config = function()
      -- configure the plugin here
      require("plantuml").setup({
        renderer = {
          type = "image",
          options = {
            prog = "nsxiv",
            dark_mode = true,
            format = "png", -- Allowed values: nil, 'png', 'svg'.
          },
        },
        render_on_write = true,
      })
    end,
  },
}
