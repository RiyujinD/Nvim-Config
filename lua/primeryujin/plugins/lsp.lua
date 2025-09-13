-- plugins/lsp.lua
-- LSP + Mason + Fidget + LazyDev (keeps your original deps and behavior)
local root_files = {
	".luarc.json",
	".luarc.jsonc",
	".luacheckrc",
	".stylua.toml",
	"stylua.toml",
	"selene.toml",
	"selene.yml",
	".git",
	"requirements.txt",
	"manage.py",
	"app.py",
}

local function make_root_dir(fname)
	-- Trying project root files first
	local root_files_found = vim.fs.find(root_files, { path = fname, upward = true })
	if #root_files_found > 0 then
		return vim.fs.dirname(root_files_found[1])
	end

	-- Fallback to git root
	local git_root = vim.fs.find(".git", { path = fname, upward = true })[1]
	if git_root then
		return vim.fs.dirname(git_root)
	end

	-- Fallback to file's directory
	return vim.fs.dirname(fname)
end

return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"stevearc/conform.nvim",
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"hrsh7th/nvim-cmp",
		"L3MON4D3/LuaSnip",
		"saadparwaiz1/cmp_luasnip",
		"j-hui/fidget.nvim",
		{
			"folke/lazydev.nvim",
			ft = "lua",
			opts = {
				library = {
					{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				},
			},
		},
	},
	opts = {
		root_files = root_files,
		servers = {
			-- LSP servers
			clangd = {},
			pyright = {},
			sqls = {},
			sqlls = {},
			ts_ls = {},
			html = {},
			emmet_ls = {},
			cssls = {},
			jsonls = {},
			yamlls = {},
			marksman = {},
			rust_analyzer = {},
			tailwindcss = {},
			lua_ls = {
				settings = {
					Lua = {
						runtime = {
							version = "LuaJIT",
							path = vim.split(package.path, ";"),
						},
						diagnostics = {
							globals = { "vim" },
						},
						workspace = {
							library = {
								[vim.fn.expand("$HOME/.config/nvim")] = true,
								[vim.fn.stdpath("config") .. "/lua"] = true,
							},
							checkThirdParty = false,
						},
						telemetry = { enable = false },
					},
				},
				root_dir = make_root_dir,
			},
		},
		on_attach = function(_, bufnr)
			local map = function(mode, lhs, rhs, desc)
				vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
			end
			map("n", "gd", vim.lsp.buf.definition, "Go to definition")
			map("n", "gr", vim.lsp.buf.references, "Go to references")
			map("n", "K", vim.lsp.buf.hover, "Hover docs")
			map("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
			map("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
		end,
		capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities()),
	},
	config = function(_, opts)
		-- Fidget setup
		require("fidget").setup({})
		-- Mason setup
		require("mason").setup()
		require("mason-lspconfig").setup({
			ensure_installed = vim.tbl_keys(opts.servers),
		})

		local lspconfig = require("lspconfig")
		for name, cfg in pairs(opts.servers) do
			cfg = vim.tbl_extend("force", {
				capabilities = opts.capabilities,
				on_attach = opts.on_attach,
				root_dir = make_root_dir, -- use modern root_dir for all servers
			}, cfg)

			-- Disable LSP formatting (Conform will handle it)
			if cfg.capabilities then
				cfg.capabilities.documentFormattingProvider = false
			end

			lspconfig[name].setup(cfg)
		end

		vim.diagnostic.config({
			virtual_text = true,
			signs = true,
			underline = true,
			update_in_insert = false,
			float = {
				focusable = false,
				style = "minimal",
				border = "rounded",
				source = true,
				header = "",
				prefix = "",
			},
		})
	end,
}
