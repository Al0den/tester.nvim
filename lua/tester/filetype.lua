local function init(M, arg)
    local userType = arg.type or nil
    local tbl = M.opts.askForType
    local current_type
    local current_file = vim.api.nvim_buf_get_name(0)
    local extension = getFileExtension(current_file)
    if userType ~= nil then
        current_type = "." .. userType
    elseif has_value(tbl, extension) or type == "ask" then
        local name = vim.fn.input("Type: ", "", "file")
        current_type = "." .. name
    else
        current_type = extension
    end
    return current_type
end

local function askForType()
    local name = vim.fn.input("Type: ", "", "file")
    return name
end

function getType(M, arg)
    local type
    if arg["type"] == "ask" then
        type = "." .. askForType()
    else
        type = init(M, arg)
    end
    return type
end

return getType
