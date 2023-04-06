require("utils")
require("tester.filetype")

local defaults = require("tester.defaults")

local va = vim.api
local path = vim.fn.stdpath("run") .. "/trash"

local alreadyOpened = {}
local M = {}

M.setup = function(opts)
    M.opts = vim.tbl_deep_extend('force', defaults, opts or {})
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
    local dir = arg["dir"] or M.opts.defaultDir
    local format = arg["format"] or M.opts.formatOnOpen
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
            if format then vim.lsp.buf.format(0) end
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

M.write = function(opts)
    opts.path = opts.path or M.writeDir or "cwd"
    opts.name = opts.name or "ask"
    if opts.name == "ask" then
        local newName = vim.fn.input("Name:", "", "file")
        opts.name = newName or "testerFile"
    end
    local testerWinID = M.isOpened()
    if testerWinID == false then
        return print("No tester file opened")
    end
    if opts.path == "cwd" then
        opts.path = vim.fn.getcwd() .. "/"
    elseif opts.path == "ask" then
        local newPath = vim.fn.input("Path:", "", "file")
        opts.path = newPath
    end
    local extension = getFileExtension(va.nvim_buf_get_name(vim.fn.winbufnr(testerWinID)))
    opts.path = ((opts.path):gsub("~", os.getenv("HOME"))) .. opts.name .. extension
    local _, err = os.rename(opts.path, opts.path)
    local file = io.open(opts.path, "w+")
    local content = vim.api.nvim_buf_get_lines(vim.fn.winbufnr(testerWinID), 0, vim.api.nvim_buf_line_count(0), false)
    if err and file ~= nil then
        file:write(table.concat(content, "\n"))
        file:close()
        print("Saved file to: " .. opts.path)
    else
        print("File already exists, overwrite?")
        local ans = vim.fn.input("[y/n]", "", "file")
        if ans == "y" and file ~= nil then
            file:write(table.concat(content, "\n"))
            file:close()
            print("Saved file to: " .. opts.path)
        else
            print("No data saved/erased")
        end
    end
end

return M
