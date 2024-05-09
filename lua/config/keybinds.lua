vim.keymap.set("n", "<leader>xd", vim.diagnostic.open_float, { desc = "Show Line Diagnostic" })
vim.keymap.set("n", "<leader>xn", vim.diagnostic.goto_next, { desc = "Jump to next diagnostic" })
vim.keymap.set("n", "<leader>xp", vim.diagnostic.goto_prev, { desc = "Jump to previous diagnostic" })

vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Jump to definition" })
vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename symbol" })

vim.keymap.set('t', '<C-t>h', "<C-\\><C-n><C-w>h", {silent = true, desc = "Leave Terminal Mode"})
vim.keymap.set(
	{'t', 'n'},
	'<C-t><C-t>',
	function ()
		require("FTerm").toggle()
	end,
	{ silent = true, desc = "Close Terminal" }
)

vim.keymap.set("n", "<leader>zl", "<cmd>Lazy<CR>", { desc = "Open Lazy" })
vim.keymap.set("n", "<leader>zm", "<cmd>Mason<CR>", { desc = "Open Mason" })

vim.keymap.set("n", "<leader>bd", "<cmd>bd<CR>", { desc = "Close Buffer" })
