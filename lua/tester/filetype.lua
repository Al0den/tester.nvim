function init(type, tbl)
    local current_type
    local current_file = vim.api.nvim_buf_get_name(0)
    local extension = getFileExtension(current_file)
    if type ~= nil then
        current_type = "." .. type
    elseif has_value(tbl, extension) then
        local name = vim.fn.input("Type: ", "", "file")
        current_type = "." .. name
    else
        current_type = extension
    end
    local path = vim.fn.stdpath('run') .. "/trash" .. current_type
    return path
end

return {
    init = init
}
