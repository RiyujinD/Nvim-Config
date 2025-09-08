return {
  {
    "folke/trouble.nvim",
    opts = {
      icons = false,  -- pass options directly via 'opts'
    },
    keys = {
      { "<leader>tt", function() require("trouble").toggle() end, desc = "Toggle Trouble" },
      { "[t", function() require("trouble").next({ skip_groups = true, jump = true }) end, desc = "" },
      { "]t", function() require("trouble").previous({ skip_groups = true, jump = true }) end, desc = "" },
    },
  },
}
