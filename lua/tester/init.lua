require("utils")
require("tester.filetype")

local va = vim.api
local path = vim.fn.stdpath("run") .. "/trash"

local M = {}

M.setup = function(opts)
    M.opts = opts or { dir = "vertical" }
    M.opts.askForType = M.opts.askForType or { ".tex" }
end

local function winbg()
    vim.cmd [[set winhighlight=Normal:testerNormal,EndOfBuffer:testerNormal,SignColumn:testerNormal ]]
end

local function create_file(path)
    local file = assert(io.open(path, "w"))
    io.close(file)
end

local function getCurrentBuffers()
    local bufs = vim.tbl_filter(function(t)
        return va.nvim_buf_is_loaded(t) and vim.fn.buflisted(t)
    end, va.nvim_list_bufs())
    return bufs
end

M.isOpened = function()
    for _, buff in pairs(getCurrentBuffers()) do
        local ok, _ = pcall(vim.api.nvim_buf_get_var, buff, "owner")
        if ok and vim.fn.bufwinid(buff) ~= -1 then
            return vim.fn.bufwinid(buff)
        end
    end
    return false
end

M.open = function(args)
    arg = args or {}
    local type = getType(M, arg)
    local dir = arg["dir"] or "vsplit"
    if M.isOpened() then
        vim.fn.win_gotoid(M.isOpened())
    else
        create_file(path .. type)
        vim.cmd(dir .. " " .. path .. type)
        print(path .. type)
        vim.api.nvim_buf_set_var(va.nvim_get_current_buf(), "owner", "tester")
        vim.bo.bufhidden = "delete"
        winbg()
    end
end

M.clear = function()
    for _, buff in ipairs(getCurrentBuffers()) do
        local ok, _ = pcall(vim.api.nvim_buf_get_var, buff, "owner")
        if ok then
            local ext = getFileExtension(vim.api.nvim_buf_get_name(buff))
            local stat = vim.fn.bufwinid(buff)
            os.remove(vim.api.nvim_buf_get_name(buff))
            va.nvim_win_close(M.isOpened(), 0)
            if stat ~= 1 then
                M.open({ type = ext })
            end
        end
    end
end

return M
