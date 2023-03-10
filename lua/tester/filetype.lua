function init(M)
    local tbl = M.opts.askForType
    local current_type
    local current_file = vim.api.nvim_buf_get_name(0)
    local extension = getFileExtension(current_file)
    if has_value(tbl, extension) or type == "ask" then
        local name = vim.fn.input("Type: ", "", "file")
        current_type = "." .. name
    else
        current_type = extension
    end
    return current_type
end

return {
    init = init
}
