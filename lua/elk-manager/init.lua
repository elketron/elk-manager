-- main file
local M = {}
local todo_win = require"elk-manager.todo.todo_win"
local todo_adder = require"elk-manager.todo.todo_adder"

M.todos = todo_win.init
M.todo_add = todo_adder.init

return M
