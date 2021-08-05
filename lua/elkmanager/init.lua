-- main file
local todo = require"todo"
local files = require"file_make"
local utils = require"utils.utils"
llocal other_chars = {ocal win = require"window"

win.open_window()
win.key_maps()
win.update(data)
--files.add("test","test/test.hpp","header", "cpp")

--files.get_template("test", "~/Projects/elk-manager/tests", "test2")


todo.add_group("group 1")
todo.add_group("group 2")
data = todo.add("group 1", "test4", "20201999", "this is a test")
data = todo.add("group 1", "test2", "20201999", "this another test")
data = todo.add("group 2", "test", "20201999", "this is a test")

--local data = {}

--local sub_data = {"test", "words"}

--win.update_todos(data)

--data[1] = {}
--table.insert(data[1], sub_data)
local function print_arr()
    for key, val in next,data,nil do
        for k,v in next,val,nil do
            for i,j in next,v, nil do
                print(key,k,i,j)
            end
            print()
        end
    end
end
print_arr()
--print()
--removing items
-- not working
--data.remove("1")
--print_arr()

-- set as done
-- working
--todo.done('1', 1)

-- change item
--todo.edit("1", 1, todo.indexes["title"], "test3")
--print_arr()

--todo.write("todo.json")
