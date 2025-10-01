local function find_root_path()
	local bufname = vim.api.nvim_buf_get_name(0)

	-- Setting the path to the buffer abs path head (folder) or default current directory
	local path = (bufname ~= "" and vim.fn.fnamemodify(bufname, ":p:h")) or vim.fn.getcwd()
	local root_markers = {
		".git",
		"app.py",
		"pyproject.toml",
		"requirements.txt",
		"setup.py",
	}
	local home = os.getenv("HOME")

	while path and path ~= "" and path ~= "/" do
		for _, marker in ipairs(root_markers) do
			local marker_path = path .. "/" .. marker
			if vim.fn.filereadable(marker_path) == 1 or vim.fn.isdirectory(marker_path) == 1 then
				return path
			end
		end

		if path == home then
			break
		end -- Stop going up at $HOME
		path = vim.fn.fnamemodify(path, ":h") -- Go up a dir
	end

	-- Fallback
	return vim.fn.getcwd()
end

local function find_venv_py()
	-- If venv is already activate we can store the path with os
	local venv_env = os.getenv("VIRTUAL_ENV") or os.getenv("CONDA_PREFIX")
	if venv_env and venv_env ~= "" then
		local venv_python = venv_env .. "/bin/python"
		if vim.fn.executable(venv_python) == 1 then
			return venv_python
		end
	end

	local root = find_root_path()
	if root and root ~= "" then
		local venv_exe_path = root .. "/venv/bin/python3" -- If venv not active python3 safer
		if vim.fn.executable(venv_exe_path) == 1 then
			return venv_exe_path
		end
		-- Fallback
		local venv_exe_path_fb = root .. "/venv/bin/python"
		if vim.fn.executable(venv_exe_path_fb) == 1 then
			return venv_exe_path_fb
		end
	end

	-- Look in the PATH for the exe if venv activate else default to /usr/bin/python
	if vim.fn.executable("python3") == 1 then
		return "python3"
	end
	if vim.fn.executable("python") == 1 then
		return "python"
	end
	return nil
end

return {
	"jay-babu/mason-nvim-dap.nvim",
	lazy = true,
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"mason-org/mason.nvim",
		"mfussenegger/nvim-dap",
	},
	opts = {
		ensure_installed = {
			"debugpy", -- Python
			"codelldb", -- C
			"node2", -- JS/TS
			"local-lua-debugger-vscode", -- Lua
		},
		automatic_setup = true,
		handlers = {
			-- Default handler for servers without specific configs
			function(config)
				require("mason-nvim-dap").default_setup(config)
			end,

			-- Python
			python = function(config)
				config.adapters = config.adapters or {}
				config.configurations = config.configurations or {}
				config.configurations.python = config.configurations.python or {}

				local adapter_exe = vim.fn.exepath("debugpy-adapter")
				if adapter_exe ~= "" then
					config.adapters.python = {
						type = "executable",
						command = adapter_exe,
					}
				else
					config.adapters.python = {
						type = "executable",
						command = find_venv_py() or "python3",
						args = { "-m", "debugpy.adapter" },
					}
				end

				vim.list_extend(config.configurations.python, {
					{
						type = "python",
						request = "launch",
						name = "Python: debugger (auto venv)",
						program = "${file}",
						cwd = "${workspaceFolder}",
						pythonPath = function()
							return find_venv_py()
						end,
						console = "integratedTerminal",
					},
					{
						type = "python",
						request = "launch",
						name = "Flask: debugger (no-reload, auto venv)",
						module = "flask",
						args = { "run", "--no-reload" },
						env = { FLASK_APP = "app.py" },
						cwd = "${workspaceFolder}",
						pythonPath = function()
							return find_venv_py()
						end,
						console = "integratedTerminal",
					},
					{
						type = "python",
						request = "attach",
						name = "Flask: attach to debugpy (127.0.0.1:5678)",
						host = "127.0.0.1",
						port = 5678,
					},
					{
						type = "python",
						request = "launch",
						name = "Django: launch (manage.py runserver)",
						program = "${workspaceFolder}/manage.py",
						args = { "runserver", "0.0.0.0:8000" },
						cwd = "${workspaceFolder}",
						pythonPath = function()
							return find_venv_py()
						end,
						console = "integratedTerminal",
					},
					{
						type = "python",
						request = "attach",
						name = "Django: attach to debugpy (127.0.0.1:5678)",
						host = "127.0.0.1",
						port = 5678,
					},
				})

				require("mason-nvim-dap").default_setup(config)
			end,

			-- Lua
			nlua = function(config)
				config.adapters = config.adapters or {}
				config.configurations = config.configurations or {}
				config.configurations.lua = config.configurations.lua or {}

				config.adapters.nlua = {
					type = "executable",
					command = vim.fn.exepath("lua-debug-adapter") or "lua",
				}

				vim.list_extend(config.configurations.lua, {
					{
						type = "nlua",
						request = "launch",
						name = "Lua: launch current file",
						program = "${file}",
						cwd = "${workspaceFolder}",
					},
				})

				require("mason-nvim-dap").default_setup(config)
			end,

			-- Node2 (JS/TS)
			node2 = function(config)
				config.adapters = config.adapters or {}
				config.configurations = config.configurations or {}
				config.configurations.javascript = config.configurations.javascript or {}
				config.configurations.typescript = config.configurations.typescript or {}

				config.adapters.node2 = {
					type = "executable",
					command = vim.fn.exepath("node-debug2-adapter") or "node",
				}

				local js_ts_config = {
					type = "node2",
					request = "launch",
					name = "JS/TS: launch current file",
					program = "${file}",
					cwd = "${workspaceFolder}",
				}

				vim.list_extend(config.configurations.javascript, { js_ts_config })
				vim.list_extend(config.configurations.typescript, { js_ts_config })

				require("mason-nvim-dap").default_setup(config)
			end,

			-- C
			codelldb = function(config)
				config.adapters = config.adapters or {}
				config.configurations = config.configurations or {}
				config.configurations.c = config.configurations.c or {}

				config.adapters.codelldb = {
					type = "executable",
					command = vim.fn.exepath("codelldb") or "codelldb",
				}

				vim.list_extend(config.configurations.c, {
					{
						type = "codelldb",
						request = "launch",
						name = "C: launch current file",
						program = function()
							return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
						end,
						cwd = "${workspaceFolder}",
						stopOnEntry = false,
					},
				})

				require("mason-nvim-dap").default_setup(config)
			end,
		},
	},
}
