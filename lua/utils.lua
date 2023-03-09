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

function stringStartsWith(str, beg)
    return str:find("^" .. beg) ~= nil
end

function get_file_name(file)
    local file_name = file:match("[^/]*.lua$")
    return file_name:sub(0, #file_name - 4)
end

return {
    file_exists = file_exists,
    getFileExtension = getFileExtension,
    has_value = has_value,
    stringStartsWith = stringStartsWith,
    get_file_name = get_file_name
}
