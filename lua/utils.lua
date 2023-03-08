function file_exists(name)
    local f = io.open(name, "r")
    return f ~= nil and io.close(f)
end

function getFileExtension(url)
    return url:match("^.+(%..+)$")
end

function has_value(tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

return {
    file_exists = file_exists,
    getFileExtension = getFileExtension,
    has_value = has_value
}
