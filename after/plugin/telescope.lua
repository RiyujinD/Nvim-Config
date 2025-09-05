local builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>fs", builtin.find_files, { desc = "Telescope: Find Files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope: Live Grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope: Buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope: Help Tags" })
vim.keymap.set("n", "<C-p>", builtin.git_files, {})

-- Prompted grep
vim.keymap.set("n", "<leader>ps", function()
    builtin.grep_string({ search = vim.fn.input("Grep > ") })
end, {})
