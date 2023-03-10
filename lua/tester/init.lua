require("utils")
require("tester.filetype")

local defaults = require("tester.defaults")
local va = vim.api
local path = vim.fn.stdpath("run") .. "/trash"

local M = {}

local alreadyOpened = {}

M.setup = function(opts)
    M.opts = opts or defaults.opts
    M.opts.askForType = M.opts.askForType or defaults.askForType
    M.opts.defaultContent = M.opts.defaultContent or defaults.defaultContent
    require("tester.autocmd").initialisation(alreadyOpened)
end

local function winbg()
    vim.cmd [[set winhighlight=EndOfBuffer:testerNormal,SignColumn:testerNormal ]]
end

local function create_file(path, type)
    local _, err, _ = os.rename(path, path)
    local file = io.open(path, "a")
    if M.opts.defaultContent[type:sub(2)] ~= nil and file ~= nil and err then
        local finalString = M.opts.defaultContent[type:sub(2)]:gsub("@", '')
        file:write(finalString)
        io.close(file)
        return true
    else
        io.close(file)
        return false
    end
end

local function getCurrentBuffers()
    local bufs = vim.tbl_filter(function(t)
        return va.nvim_buf_is_loaded(t) and vim.fn.buflisted(t)
    end, va.nvim_list_bufs())
    return bufs
end

M.isOpened = function()
    for _, buff in pairs(getCurrentBuffers()) do
        local ok, _ = pcall(va.nvim_buf_get_var, buff, "owner")
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
        local new = create_file(path .. type, type)
        vim.cmd(dir .. " " .. path .. type)
        local defaultC = M.opts.defaultContent[type:sub(2)]
        if defaultC ~= nil and string.find(defaultC, "@") ~= nil and new then
            local split = mysplit(defaultC, "@")[1]
            local _, line = split:gsub("\n", "")
            local colum = string.len((mysplit(split, "\n")[line]))
            va.nvim_win_set_cursor(0, { line + 1, colum })
        elseif alreadyOpened[type] ~= nil then
            va.nvim_win_set_cursor(0, alreadyOpened[type].pos)
        end
        va.nvim_buf_set_var(va.nvim_get_current_buf(), "owner", "tester")
        vim.bo.bufhidden = "delete"
        winbg()
        alreadyOpened[type] = {
            pos = va.nvim_win_get_cursor(0)
        }
    end
end

M.clear = function()
    alreadyOpened = {}
    for _, buff in ipairs(getCurrentBuffers()) do
        local ok, _ = pcall(va.nvim_buf_get_var, buff, "owner")
        if ok then
            local ext = getFileExtension(va.nvim_buf_get_name(buff))
            local stat = vim.fn.bufwinid(buff)
            os.remove(va.nvim_buf_get_name(buff))
            va.nvim_win_close(M.isOpened(), 0)
            if stat ~= 1 then M.open({ type = ext:sub(2) }) end
        end
    end
end

return M
