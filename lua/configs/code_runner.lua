local M = {}
local term = require("nvchad.term")

local runners = {
    c = "cd %dir && clang -pedantic-errors -Wall -Wextra -std=c23 -o %name *.c && %dir/%name",
    cpp = "cd %dir && clang++ -pedantic-errors -Wall -Wextra -std=c++23 -o %name *.cpp && %dir/%name",
    go = "go run %file",
    python = "python3 -u %file",
}

local function run_command(cmd)
    local file = vim.fn.expand("%:p")
    local dir = vim.fn.expand("%:p:h")
    local name = vim.fn.expand("%:t:r")

    cmd = cmd:gsub("%%file", file)
    cmd = cmd:gsub("%%dir", dir)
    cmd = cmd:gsub("%%name", name)

    term.toggle({ pos = "sp", id = "htoggleTerm" })
    vim.defer_fn(function()
        vim.api.nvim_chan_send(vim.b.terminal_job_id, cmd .. "\n")
    end, 100)
end

M.run = function()
    local ft = vim.bo.filetype
    local cmd = runners[ft]

    if not cmd then
        vim.notify("No runner for: " .. ft)
        return
    end

    vim.cmd("write")
    run_command(cmd)
end

M.toggle = function()
    term.toggle({ pos = "sp", id = "htoggleTerm" })
end

M.stop = function()
    term.toggle({ pos = "sp", id = "htoggleTerm" })
    vim.defer_fn(function()
        vim.api.nvim_chan_send(vim.b.terminal_job_id, "\003")
    end, 100)
end

return M
