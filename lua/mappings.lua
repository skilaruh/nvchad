require("nvchad.mappings")

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP: Code Action" })

map("n", "<leader>r", function()
    require("configs.code_runner").run()
end, { desc = "Run current file in horizontal terminal" })
