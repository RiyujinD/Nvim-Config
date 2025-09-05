return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",        -- required core library
        "nvim-telescope/telescope-fzf-native.nvim", -- optional C sorter for speed
    },
    build = "make",  -- compiles the native C extension
    keys = {
        { "<leader>fs", function() require("telescope.builtin").find_files() end, desc = "Find Files" },
        { "<leader>fg", function() require("telescope.builtin").live_grep() end, desc = "Live Grep" },
        { "<leader>fb", function() require("telescope.builtin").buffers() end, desc = "Buffers" },
        { "<leader>fh", function() require("telescope.builtin").help_tags() end, desc = "Help Tags" },
        { "<C-p>", function()
            local ok = pcall(require("telescope.builtin").git_files)
            if not ok then
                require("telescope.builtin").find_files()
            end
        end, desc = "Git Files / Fallback" },
        { "<leader>ps", function()
            require("telescope.builtin").grep_string({ search = vim.fn.input("Grep > ") })
        end, desc = "Prompted Grep" },
    },
    config = function()
        -- Load FZF extension if installed
        local telescope = require("telescope")
        pcall(telescope.load_extension, "fzf")
    end,
}

