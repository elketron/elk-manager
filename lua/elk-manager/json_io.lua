local json = require"elk-manager.utils.json"

local M = {}

function M.read(file)
    file = io.open(file,"r")
    io.input(file)
    local temp = json.decode(io.read())
    io.close(file)
    return temp
end

function M.write(file)
    file = io.open(file,"w")
    io.output(file)
    io.write(json.encode(data))
    io.close(file)
end

return M
