-- main file
local M = {}
local todo_win = require"elk-manager.todo.todo_win"
local add_group = require"elk-manager.todo.group_add"

M.todos = todo_win.init
M.add_group = add_group.init

return M
