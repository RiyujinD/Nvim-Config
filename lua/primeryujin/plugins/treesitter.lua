return {
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		opts = {
			ensure_installed = {
				"c",
				"cpp",
				"lua",
				"vim",
				"vimdoc",
				"query",
				"python",
				"go",
				"rust",
				"javascript",
				"typescript",
				"tsx",
				"css",
				"lua",
				"bash",
				"json",
				"yaml",
				"markdown",
				"markdown_inline",
			},

			-- Automatically install missing parsers when entering buffer
			-- Recommendation: set to false if you don"t have `tree-sitter` CLI installed locally
			auto_install = true,
			sync_install = false,
			indent = {
				enable = true,
			},
			highlight = {
				enable = true,

				-- Disable for performance in html and large file (+100KB)
				disable = function(lang, buf)
					if lang == "html" then
						print("disabled")
						return true
					end

					local max_filesize = 100 * 1024 -- 100 KB
					local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))

					if ok and stats and stats.size > max_filesize then
						vim.notify(
							"File larger than 100KB treesitter disabled for performance",
							vim.log.levels.WARN,
							{ title = "Treesitter" }
						)
						return true
					end
				end,
			},

			incremental_selection = {
				enable = true,
				keymaps = {

					-- Start a selection at the current cursor node (e.g., a variable, expression, or function).
					init_selection = "<C-space>",
					-- Expand the selection to the parent node
					node_incremental = "<C-space>",
					-- Expand selection to scope
					scope_incremental = "<leader><C-space>",
					-- Shrink selection back down the tree
					node_decremental = "<bs>",
				},
			},
			textobjects = {
				move = {
					enable = true,
					goto_next_start = {
						["]f"] = "@function.outer",
						["]c"] = "@class.outer",
						["]a"] = "@parameter.inner",
					},
					goto_previous_start = {
						["[f"] = "@function.outer",
						["[c"] = "@class.outer",
						["[a"] = "@parameter.inner",
					},
				},
			},
		},
		config = function(_, opts)
			require("nvim-treesitter.configs").setup(opts)
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter-context",
		after = "nvim-treesitter",
		opts = {
			enable = true, -- Enable/disable the plugin require("treesitter-context").disable()
			multiwindow = false, -- Only show context in the current window
			max_lines = 0, -- No limit to context lines
			min_window_height = 0, -- Always show context regardless of window height
			line_numbers = true, -- Show line numbers in context
			multiline_threshold = 20, -- Max lines for a single context block
			trim_scope = "outer", -- Trim from outer side if context too long
			mode = "cursor", -- Calculate context based on cursor line
			separator = nil, -- Optional separator above context
			zindex = 20, -- Floating window stack order
			on_attach = nil, -- Optional per-buffer attach function
		},
	},

	{
		"windwp/nvim-ts-autotag",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		event = "BufReadPost",
		opts = {},
	},

	{
		"nvim-treesitter/playground",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		cmd = "TSPlaygroundToggle",
		opts = {},
	},
}
