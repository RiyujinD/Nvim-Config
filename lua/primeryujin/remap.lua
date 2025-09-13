vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- Mose selected text and move it + auto endent 
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- auto center cursor to windows during 'scrolling'
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Mark the cursor place to keep it the same when using 'J'
vim.keymap.set("n", "J", "mzJ`z")

-- Keep seach term in center to window
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Paste without remplacing the registery 
vim.keymap.set("x", "<leader>p", [["_dP]])
-- Delete to void registery
vim.keymap.set({ "n", "v" }, "<leader>d", "\"_d")

-- Yank to the clipboard registery
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])


vim.keymap.set("i", "<C-c>", "<Esc>")


vim.keymap.set("n", "<leader>tm", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
vim.keymap.set("n", "<leader>tms", "<cmd>silent !tmux-sessionizer -s 0 --vsplit<CR>")
vim.keymap.set("n", "<leader>tmg", "<cmd>silent !tmux neww tmux-sessionizer -s 0<CR>")




-- Navigation centering
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")



vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

vim.keymap.set("n", "=ap", "ma=ap'a")

