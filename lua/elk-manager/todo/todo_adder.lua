local todo = require"elk-manager.todo.todo"
local win = require"elk-manager.window"

local state = 0

local g_win,t_win
local path = "elk-manager.todo.todo_adder"
local mappings = {
    ['<cr>'] = '"'..path..'".group_add()',
    ['<esc>'] = '"'..path..'".close()'
}

local M = {}

function M.close()
    win.close_window(g_win.win)
end

function M.group_add()
    local line = vim.api.nvim_buf_get_lines(g_win.buf,1,2,false)
    todo.add_group(line[1])
    --win.close_window(g_win.win)
    --win.close_window(t_win.win)
  --  vim.api.nvim_set_current_buf(t_win.buf)
    vim.api.nvim_set_current_win(t_win.win)
    win.print(t_win.buf,{line[1]})
 --   win.print(g_win.buf,{"hello"})
    win.print(g_win.buf,{"hello"})
    print(vim.api.nvim_buf_is_loaded(g_win.buf), vim.api.nvim_buf_is_valid(g_win.buf))
end

function M.init(val)
    state = val
    t_win = win.open_window({w_width = 20,w_height = 5,w_row = 50,w_col = 70})
    g_win = win.open_window({w_width = 50,w_height = 5,w_row = 50,w_col = 25})
    vim.api.nvim_set_current_win(t_win.win)
    win.win_title(t_win.buf,"Test")
    
    vim.api.nvim_set_current_win(g_win.win)
    win.win_title(g_win.buf,"Add Group")
    vim.api.nvim_win_set_cursor(g_win.win, {2,0})
    win.keymaps(g_win.buf,'i', mappings)
    --vim.api.nvim_buf_set_option(win.get_buf(), "insertmode", true)
end

return M
