-- lua/primeryujin/plugins/mason.lua
return {
	"williamboman/mason.nvim",
	opts = {},
	config = function(_, opts)
		require("mason").setup(opts)

		-- Auto-install required formatters
		local mason_registry = require("mason-registry")
		local to_install = {
			"clang-format",
			"stylua",
			"gofumpt",
			"rustfmt",
			"prettierd",
			"prettier",
			"black",
			"sqlfluff",
			"djlint",
			"shfmt",
		}

		for _, pkg in ipairs(to_install) do
			if not mason_registry.is_installed(pkg) then
				mason_registry.get_package(pkg):install()
			end
		end
	end,
}
