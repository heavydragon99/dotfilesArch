return {
  {
    "luukvbaal/statuscol.nvim",
    config = function()
      local function abs_lnum()
        return string.format("%3d", vim.v.lnum)
      end

      local function rel_lnum()
        local cur = vim.fn.line(".")
        if vim.v.lnum == cur then
          return "   "
        end
        return string.format("%3d", math.abs(vim.v.lnum - cur))
      end

      require("statuscol").setup({
        setopt = true,
        segments = {
          {
            sign = {
              namespace = { "gitsigns.*" },
              name = { "gitsigns.*" },
            },
          },
          {
            sign = {
              namespace = { ".*" },
              name = { ".*" },
              auto = true,
            },
          },
          {
            text = { abs_lnum, " " },
          },
          {
            text = { rel_lnum, " " },
          },
        },
      })
    end,
  },

  {
    "folke/snacks.nvim",
    opts = {
      statuscolumn = { enabled = false },
    },
  },
}
