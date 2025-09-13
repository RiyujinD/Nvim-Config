return {
	"folke/which-key.nvim",
    lazy = false,
    priority = 900,
	opts = {
		spec = {
			-- Visual mode: Decrement Selection with Backspace
			{ "<BS>", desc = "Decrement Selection", mode = "x" },

			-- Normal + Visual mode: Increment Selection with Ctrl+Space
			{ "<C-Space>", desc = "Increment Selection", mode = { "n", "x" } },
		},
	},
}
