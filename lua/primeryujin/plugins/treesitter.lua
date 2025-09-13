-- Helper: Function to deduplicate a list
-- Used to ensure parsers in `ensure_installed` are unique
local function dedupList(list)
	local popList, newList = {}, {}
	for _, value in ipairs(list or {}) do
		if not popList[value] then
			popList[value] = true
			table.insert(newList, value)
		end
	end
	return newList
end

return {
	-- Main Treesitter plugin
	{
		"nvim-treesitter/nvim-treesitter",
		version = false,
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile", "VeryLazy" },
		lazy = vim.fn.argc(-1) == 0,
		init = function(plugin)
			-- PERF: ensure treesitter queries/predicates are available on rtp early
			require("lazy.core.loader").add_to_rtp(plugin)
			require("nvim-treesitter.query_predicates")
		end,
		cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
		keys = {
			{ "<c-space>", desc = "Increment Selection" },
			{ "<bs>", desc = "Decrement Selection", mode = "x" },
		},
		---@type TSConfig
		---@diagnostic disable-next-line: missing-fields
		opts = {
			modules = {}, -- optional module table (kept empty to satisfy types)
			sync_install = false,
			auto_install = true,
			ignore_install = {},
			-- Parsers
			ensure_installed = {
				"c",
				"diff",
				"html",
				"javascript",
				"jsdoc",
				"json",
				"jsonc",
				"lua",
				"luadoc",
				"luap",
				"markdown",
				"markdown_inline",
				"printf",
				"python",
				"tsx",
				"typescript",
				"xml",
				"yaml",
				"vim",
				"vimdoc",
				"bash",
			},

			highlight = { enable = true },
			indent = { enable = true },
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-space>",
					node_incremental = "<C-space>",
					scope_incremental = false,
					node_decremental = "<bs>",
				},
			},

			-- Textobjects
			textobjects = {
				move = {
					enable = true,
					goto_next_start = {
						["]f"] = "@function.outer",
						["]c"] = "@class.outer",
						["]a"] = "@parameter.inner",
					},
					goto_next_end = {
						["]F"] = "@function.outer",
						["]C"] = "@class.outer",
						["]A"] = "@parameter.inner",
					},
					goto_previous_start = {
						["[f"] = "@function.outer",
						["[c"] = "@class.outer",
						["[a"] = "@parameter.inner",
					},
					goto_previous_end = {
						["[F"] = "@function.outer",
						["[C"] = "@class.outer",
						["[A"] = "@parameter.inner",
					},
				},
			},
		},

		---@param opts TSConfig
		config = function(_, opts)
			-- Deduplicate `ensure_installed`, useful if some other plugin/spec added languages
			if type(opts.ensure_installed) == "table" then
				opts.ensure_installed = dedupList(opts.ensure_installed)
			end

			-- Call setup at runtime after chaging some value to be sure it runs with correct binding
			require("nvim-treesitter.configs").setup(opts)
		end,
	},

	-- Treesitter Textobjects extension
	-- (adds extra movement and selection around functions, classes, etc.)
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		event = "VeryLazy",
		config = function(_, opts)
			local textobjects_cfg = {
				modules = {},
				sync_install = false,
				auto_install = true,
				ignore_install = {},
				ensure_installed = { "lua", "python", "javascript", "go", "rust" },
				highlight = { enable = true },
				indent = { enable = true },

				-- Textobjects binds defined in the main opts
				textobjects = opts.textobjects,
			}

			-- Call setup again with a full table, it duplicate a few keys from the main
			-- setup, but keeps the exact behavior
			require("nvim-treesitter.configs").setup(textobjects_cfg)

			-- When in diff mode, prefer default vim text objects c & C instead of treesitter ones.
			local move = require("nvim-treesitter.textobjects.move") ---@type table<string,fun(...)>
			local configs = require("nvim-treesitter.configs")
			for name, fn in pairs(move) do
				if name:find("goto") == 1 then
					move[name] = function(q, ...)
						if vim.wo.diff then
							local config = configs.get_module("textobjects.move")[name] ---@type table<string,string>
							for key, query in pairs(config or {}) do
								if q == query and key:find("[%]%[][cC]") then
									vim.cmd("normal! " .. key)
									return
								end
							end
						end
						return fn(q, ...)
					end
				end
			end
		end,
	},

	-- Auto-tagging (for HTML, JSX, etc.)
	{
		"windwp/nvim-ts-autotag",
		event = { "BufReadPost", "BufNewFile" },
		opts = {},
	},

	-- Playground: Treesitter debugging/visualization
	{
		"nvim-treesitter/playground",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		cmd = {
			"TSPlaygroundToggle",
			"TSPlaygroundFocus",
			"TSPlaygroundUnfocus",
			"TSPlaygroundShow",
			"TSPlaygroundHide",
			"TSPlaygroundUpdate",
		},
		config = function()
			require("nvim-treesitter.configs").setup({
				modules = {},
				sync_install = false,
				auto_install = true,
				ignore_install = {},
				ensure_installed = {},

				-- Playground-specific configuration
				playground = {
					enable = true,
					updatetime = 25,
					persist_queries = false,
				},
			})
		end,
	},
}
