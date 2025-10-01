return {
	"WhoIsSethDaniel/mason-tool-installer.nvim",
	lazy = false,
	dependencies = { "mason-org/mason.nvim" },
	opts = {
		ensure_installed = {
			-- Formatters
			"clang-format", -- C/C++
			"stylua", -- lua
			"prettierd", -- js / ts
			"black", -- python
			"sqlfluff", -- sql
			"djlint", -- html
			"shfmt", -- bash

			-- Linters
			"shellcheck", -- shell
			"ruff", -- python
			"eslint_d", -- js / ts

			-- Debbuger servers"
			"debugpy", -- Python
			"js-debug-adapter", -- JS/TS
			"local-lua-debugger-vscode", -- Lua
		},
		integrations = {
			["mason-lspconfig"] = true,
			["mason-nvim-dap"] = true,
			["mason-null-ls"] = false,
		},
		run_on_start = true,
		auto_update = true,
	},
}
