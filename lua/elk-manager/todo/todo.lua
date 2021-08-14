-- make a todo list and manipulate it
-- ## capabilities
-- - add todo
-- - remove todo
-- - change todo (title,description,due date)
-- - add group
-- - change done
-- - save to json file

-- table = { group: { {} } }
local jio = require"elk-manager.json_io"


local todo = {}
todo.todo_file = ".proj/todo.json"
data = {}
todo.indexes = {
    title = 1,
    description = 2,
    due_date = 3,
    done = 4
}

function todo.add(group,title,due_date,description)
    table.insert(data[group], {title,description,due_date,"false"})
end

function todo.remove(group,index)
    table.remove(data[group], index) 
end

function todo.remove_group(group)
    table.remove(data,group)
end

function todo.edit(group, id1, id2, change )
    data[group][id1][id2] = change
end

function todo.add_group(group)
    data[group] = {}
end

function todo.toggle_done(group,index)
    local done = data[group][index][4]
    local is_done = ""

    if done == "false" then
        is_done = "true"
    else 
        is_done = "false"
    end

    data[group][index][4] = is_done

end

function todo.read()
    data = jio.read(todo.todo_file)
end

function todo.write()
    jio.write(todo.todo_file)
end

return todo
