-- file for showing todos

local todo = require"elk-manager.todo.todo"
local win = require"elk-manager.window"
local add = require"elk-manager.todo.todo_add"
local gadd = require"elk-manager.todo.group_add"
local num = 1
local states = 0
local todos = {}
local out_groups = {}
local t_win
elements = 0

local M = {}
local path = '"elk-manager.todo.todo_win"'
local cur_group = ""
todo_maps = {
   ['<Up>'] =   path..'.add_to_num(-1)',
   ['<Down>'] = path..'.add_to_num(1)',
   ['<cr>'] =   path..'.update()',
   ['q'] =      path..'.close()', 
   ['g'] =      path..'.change_state(0)', -- go to groups 
   ['d'] =      path..'.toggle_todo()',
   ['at'] =     path..'.add_todo()',
   ['ag'] =     path..'.add_group()'
}

local function print_todos(val)
  local s = ""
  local out = {}
      for k,v in next,val,nil do
        for i = 1, #v,1 do
          s = s..todo_seperator..v[i]
        end
        table.insert(out,s)
        s = ""
      end
    return out
end

local function groups()
  local out = {}
  for key,val in pairs(data) do
    table.insert(out,key)
  end
  return out
end

function M.add_group()
  gadd.init(t_win.win)
end

function M.add_todo()
  print(cur_group)
  add.init(cur_group,t_win.buf,t_win.win)
end

function M.close()
  todo.write(data)
  win.close_window(t_win.win)
end

function M.change_state(state)
  states = state
  M.update()
end

function M.toggle_todo()
  todo.toggle_done(cur_group,num)
  M.change_state(2)
end

-- update screen with new content
function M.update()
  -- state 0 : group functions
  -- num doesn't matter only prints groups
  if states == 0 then
    out_groups = groups(data)
    states = 1
    elements = #out_groups
    win.print(t_win.buf,out_groups)

  --state 1 : todo function
  elseif states == 1 then
    cur_group = out_groups[num]
    todos = print_todos(data[cur_group])
    elements = #todos
    win.print(t_win.buf,todos)

  -- toggle todo
  elseif states == 2 then
    todos = print_todos(data[cur_group])
    win.print(t_win.buf,todos)
  end

  -- state 3 : add todo
  -- state 4 : add group
  -- state 5 : change todo
end

function M.add_to_num(to_add)
  num = num + to_add

  if num >= 1 and num <= elements then
    vim.api.nvim_win_set_cursor(t_win.win, {num,0})
  else 
    vim.api.nvim_win_set_cursor(t_win.win, {1,0})
    num = 1
  end
end

function M.init()
  todo.add_group("group 1")
  todo.add_group("group 2")
  todo.add("group 1", "test4", "20201999", "this is a test")
  todo.add("group 1", "test2", "20201999", "this another test")
  todo.add("group 2", "test", "20201999", "this is a test")
 
  --todo.read()
  t_win = win.open_window({w_width = 90,w_height = 90,w_row = 50,w_col = 50})
  win.keymaps(t_win.buf,"n", todo_maps)
  M.update()
end

return M

