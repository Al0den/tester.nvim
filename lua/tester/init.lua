require("utils")
require("tester.filetype")
local va = vim.api
local path = vim.fn.stdpath("run") .. "/trash"

local M = {}

M.setup = function(opts)
    M.opts = opts or {}
    M.opts.askForType = M.opts.askForType or { ".tex" }
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
    local bufferList = getCurrentBuffers()
    for _, buff in pairs(bufferList) do
        local ok, _ = pcall(vim.api.nvim_buf_get_var, buff, "owner")
        if ok and vim.fn.bufwinid(buff) ~= -1 then
            return vim.fn.bufwinid(buff)
        end
    end
    return false
end

M.open = function(args)
    local type = args["type"] or init(M)
    local dir = args["dir"] or "vsplit"
    if M.isOpened() then
        vim.fn.win_gotoid(M.isOpened())
    else
        create_file(path .. type)
        print(path .. type)
        vim.cmd(dir .. " " .. path .. type)
        vim.api.nvim_buf_set_var(va.nvim_get_current_buf(), "owner", "tester")
    end
end

return M
