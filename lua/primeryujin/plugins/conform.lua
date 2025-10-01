return {
	"stevearc/conform.nvim",
	event = { "BufReadPost", "BufNewFile" },
	dependencies = {
		"mason-org/mason.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	opts = {
		formatters_by_ft = {
			c = { "clang-format" },
			cpp = { "clang-format" },
			lua = { "stylua" },
			python = { "black" },
			go = { "gofmt" },
			javascript = { "prettierd", "prettier", stop_after_first = true },
			typescript = { "prettierd", "prettier", stop_after_first = true },
			javascriptreact = { "prettierd", "prettier", stop_after_first = true },
			typescriptreact = { "prettierd", "prettier", stop_after_first = true },
			rust = { "rustfmt" },
			sql = { "sqlfluff" },
			htmldjango = { "djlint" },
			jinja = { "djlint" },
			html = { "prettierd", "prettier", stop_after_first = true },
			css = { "prettierd", "prettier", stop_after_first = true },
			json = { "prettierd", "prettier", stop_after_first = true },
			yaml = { "prettierd", "prettier", stop_after_first = true },
			markdown = { "prettierd", "prettier", stop_after_first = true },
			sh = { "shfmt" },
		},

		formatters = {
			["clang-format"] = {
				prepend_args = {
					"-style=file",
					"-fallback-style={BasedOnStyle: LLVM, IndentWidth: 4}",
				},
			},
		},

		format_on_save = {
			timeout_ms = 500,
			lsp_format = "fallback",
		},
	},

	keys = {
		{
			"<leader>f",
			function()
				require("conform").format({ bufnr = 0 })
			end,
			desc = "Format current buffer",
		},
	},
}
