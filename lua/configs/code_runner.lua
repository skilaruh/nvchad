local M = {}
local term = require("nvchad.term")

local runners = {
    c = "cd %dir && clang -pedantic-errors -Wall -Wextra -std=c23 -o %fileNameWithoutExt *.c && %dir/%fileNameWithoutExt",
    cpp = "cd %dir && clang++ -pedantic-errors -Wall -Wextra -std=c++23 -o %fileNameWithoutExt *.cpp && %dir/%fileNameWithoutExt",
    go = "go run %filename",
    python = "python3 -u %filename",
}

-- Function to find terminal buffer by checking if it's a terminal buffer
local function get_terminal_buf()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buftype == "terminal" then
            -- Check if this buffer is currently visible in a window
            for _, win in ipairs(vim.api.nvim_list_wins()) do
                if vim.api.nvim_win_get_buf(win) == buf then
                    return buf
                end
            end
        end
    end
    return nil
end

-- Function to execute command in the visible terminal
local function execute_in_terminal(cmd)
    local buf = get_terminal_buf()

    if not buf then
        vim.notify("No visible terminal found", vim.log.levels.ERROR)
        return false
    end

    local job_id = vim.b[buf].terminal_job_id
    if not job_id then
        vim.notify("Terminal job not found", vim.log.levels.ERROR)
        return false
    end

    -- Clear terminal and run command
    vim.api.nvim_chan_send(job_id, "clear\n")
    vim.schedule(function()
        vim.api.nvim_chan_send(job_id, cmd .. "\n")
    end)

    return true
end

M.run = function()
    local buf = vim.api.nvim_get_current_buf()
    local ft = vim.bo[buf].filetype
    local file = vim.api.nvim_buf_get_name(buf)

    if file == "" then
        vim.notify("Buffer has no associated file", vim.log.levels.ERROR)
        return
    end

    local cmd = runners[ft]

    if not cmd then
        vim.notify("No runner configured for filetype: " .. ft, vim.log.levels.WARN)
        return
    end

    -- Calculate all the file-related variables
    local dir = vim.fn.fnamemodify(file, ":p:h")
    local filename = vim.fn.fnamemodify(file, ":t") -- filename with extension
    local file_name_without_ext = vim.fn.fnamemodify(file, ":t:r")

    -- Replace placeholders in order from longest to shortest to avoid partial matches
    cmd = cmd:gsub(vim.pesc("%fileNameWithoutExt"), vim.fn.shellescape(file_name_without_ext))
    cmd = cmd:gsub(vim.pesc("%filename"), vim.fn.shellescape(file)) -- %filename should be full path
    cmd = cmd:gsub(vim.pesc("%fileName"), vim.fn.shellescape(filename))
    cmd = cmd:gsub(vim.pesc("%file"), vim.fn.shellescape(file))
    cmd = cmd:gsub(vim.pesc("%dir"), vim.fn.shellescape(dir))

    -- Save the file first if modified
    if vim.bo[buf].modified then
        vim.cmd("write")
    end

    -- Toggle the horizontal terminal to ensure it's visible
    term.toggle({ pos = "sp", id = "htoggleTerm" })

    -- Wait a bit for terminal to be ready, then execute
    vim.defer_fn(function()
        if not execute_in_terminal(cmd) then
            -- If execution failed, try once more after a longer delay
            vim.defer_fn(function()
                execute_in_terminal(cmd)
            end, 200)
        end
    end, 100)
end

-- Function to stop any running process in the visible terminal
M.stop = function()
    local buf = get_terminal_buf()
    if buf then
        local job_id = vim.b[buf].terminal_job_id
        if job_id then
            vim.api.nvim_chan_send(job_id, "\x03") -- Send Ctrl+C
            vim.notify("Stopped running process", vim.log.levels.INFO)
        end
    else
        vim.notify("No visible terminal found", vim.log.levels.WARN)
    end
end

-- Function to add custom runner
M.add_runner = function(filetype, command)
    runners[filetype] = command
end

return M
