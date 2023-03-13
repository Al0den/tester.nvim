local M = {}

M.initialisation = function(alreadyOpened)
    vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        callback = function()
            local ok, _ = pcall(vim.api.nvim_buf_get_var, vim.api.nvim_win_get_buf(0), "owner")
            if ok then
                local ext = getFileExtension(vim.api.nvim_buf_get_name(0))
                alreadyOpened[ext] = {
                    pos = vim.api.nvim_win_get_cursor(0)
                }
            end
        end
    })
end

return M
