require("utils")
require("tester.filetype")

local function setup()
    vim.api.nvim_create_user_command("TesterTrash", function(opts) require "tester".open_window(opts.fargs[1]) end,
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

local function open_window(type)
    local path = init(type, askForType)
    if not file_exists(path) then
        create_file(path)
    end

    vim.cmd('vsplit ' .. path)
    vim.bo.bufhidden = "delete"
end

return {
    open_window = open_window,
    setup = setup,
    add_special_type = add_special_type
}
