local options = {
    filetype = {
        c = "cd $dir && clang -pedantic-errors -Wall -Wextra -std=c23 -o $fileNameWithoutExt *.c && $dir/$fileNameWithoutExt",
        cpp = "cd $dir && clang++ -pedantic-errors -Wall -Wextra -std=c++23 -o $fileNameWithoutExt *.cpp && $dir/$fileNameWithoutExt",
        go = "go run $dir/$fileName",
        python = "python -u $dir/$fileName",
    },
}

-- Keybinds
vim.keymap.set("n", "<leader>rr", ":RunCode<CR>", { noremap = true, silent = false })
vim.keymap.set("n", "<leader>rf", ":RunFile<CR>", { noremap = true, silent = false })
vim.keymap.set("n", "<leader>rft", ":RunFile tab<CR>", { noremap = true, silent = false })
vim.keymap.set("n", "<leader>rp", ":RunProject<CR>", { noremap = true, silent = false })
vim.keymap.set("n", "<leader>rc", ":RunClose<CR>", { noremap = true, silent = false })
vim.keymap.set("n", "<leader>crf", ":CRFiletype<CR>", { noremap = true, silent = false })
vim.keymap.set("n", "<leader>crp", ":CRProjects<CR>", { noremap = true, silent = false })

return options
