local M = {}

-- split a string into a table
function M.split(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end

-- make the path shorter to where only the name of the file remains
function M.path_shortening(s)
    b,c = string.find(s,"(%w+)%.")
    s = string.sub(s,b,c - 1)
    return s
end

return M
