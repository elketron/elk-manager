-- file that adds todo items

local win = require'elk-manager.window'
local todo = require"elk-manager.todo.todo"

local t_buf,t_win, group_of_item
local counter = 0

local item = {}

local path = '"elk-manager.todo.todo_add"'
local mappings = {
  ['<cr>'] = path..".add_item()"
}

local M = {}

function M.add_item()
  -- get curren item
  if counter >= 0 then
    line = vim.api.nvim_buf_get_lines(t_buf,1,-1,false)
    table.insert(item,line[1])
  end
  
  counter = counter + 1
  
  -- print current item to add
  if counter <= 3 then
    local s = {"title", "description","due date"}
    win.print(t_buf,{s[counter], ""})
    vim.api.nvim_win_set_cursor(t_win,{2,0})
  end
  
  -- adding todo
  if counter > 3 then
    todo.add(group_of_item,item[1], item[3], item[2])
    counter = 0
    item = {}
    local key = vim.api.nvim_replace_termcodes("<esc>", true, false, true)
    vim.api.nvim_feedkeys(key,"i",true)
    require"elk-manager.todo.todo_win".change_state(2)
  end
end

-- makes the windows
-- sets group variable
function M.init(gr,buf,wind)
  t_buf = buf
  t_win = wind
  if gr == nil then
    print("go into a group first")
    return false
  else
    group_of_item = gr
  end
  counter = 0
  win.print(buf,{gr})
  vim.api.nvim_feedkeys("i", "n", true)
  M.add_item()
  win.keymaps(t_buf,"i", mappings)

  return true
end

return M
