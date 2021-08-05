-- make a todo list and manipulate it
-- ## capabilities
-- - add todo
-- - remove todo
-- - change todo (title,description,due date)
-- - add group
-- - change done
-- - save to json file

-- table = { group: { {} } }
local jio = require"json_io"

local M = {}
data = {}
M.indexes = {
    title = 1,
    description = 2,
    due_date = 3,
    done = 4
}

function M.add(group,title,due_date,description)
    table.insert(data[group], {title,description,due_date,"false"})
    return data
end

function M.remove(group,index)
    table.remove(data[group], index) 
end

function M.remove_group(group)
    table.remove(data,group)
end

function M.edit(group, id1, id2, change )
    data[group][id1][id2] = change
end

function M.add_group(group)
    data[group] = {}
end

function M.done(group,index)
    data[group][index][4] = "true"
end

function M.read(file)
    jio.read(file)
end

function M.write(file)
    jio.write(file)
end

return M
