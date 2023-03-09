require("utils")
require("tester.filetype")

local function setup()
    vim.api.nvim_create_user_command("TesterTrash",
        function(opts) require "tester".open_window(opts.fargs[1]) end,
        { nargs = "?" })
end

local askForType = { ".tex" }

local function add_special_type(type)
    table.insert(askForType, "." .. type)
end

local function create_file(path)
    local file = assert(io.open(path, "w"))
    io.close(file)
end

local function open_window(args)
    local arg = {}
    if (args ~= nil) then
        for i in string.gmatch(args, "%S+") do
            if (i == "&") then
                i = "default"
            end
            table.insert(arg, i)
        end
    end
    local type = arg[1]
    local dir = arg[2]
    local path = init(type, askForType)
    if not file_exists(path) then
        create_file(path)
    end
    if (dir == "horizontal") then
        vim.cmd("split " .. path)
    else
        vim.cmd("vsplit " .. path)
    end
    vim.bo.bufhidden = "delete"
end

local function hide_window()
    local path = vim.api.nvim_buf_get_name(0)
    local currBuff = get_file_name(vim.api.nvim_buf_get_name(0))
    if stringStartsWith(currBuff, "trash") then
        vim.api.nvim_command(":x")
    end
end

return {
    open_window = open_window,
    setup = setup,
    add_special_type = add_special_type,
    hide_window = hide_window
}
