local json = require"utils.json"

local M = {}

function M.read(file)
    file = io.open(file,"r")
    io.input(file)
    data = json.decode(io.read())
    io.close(file)
end

function M.write(file)
    file = io.open(file,"w")
    io.output(file)
    io.write(json.encode(data))
    io.close(file)
end

return M
