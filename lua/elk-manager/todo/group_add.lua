local todo = require"elk-manager.todo.todo"
local win = require"elk-manager.window"

local state = 0

local g_win
local t_win = 0
local path = "elk-manager.todo.group_add"
local mappings = {
    ['<cr>'] = '"'..path..'".group_add()',
}

local M = {}

function M.close()
    win.close_window(g_win.win)
end

function M.group_add()
    local line = vim.api.nvim_buf_get_lines(g_win.buf,1,2,false)
    todo.add_group(line[1])
    local key = vim.api.nvim_replace_termcodes("<esc>", true, false, true)
    vim.api.nvim_feedkeys(key,"i",true)
    win.close_window(g_win.win)

    if t_win ~= nil then
        vim.api.nvim_set_current_win(t_win)
        require"elk-manager.todo.todo_win".change_state(0)
    end
end

function M.init(wind)
    t_win = wind
    g_win = win.open_window({w_width = 50,w_height = 5,w_row = 50,w_col = 25})
    
    win.win_title(g_win.buf,"Add Group")
    vim.api.nvim_win_set_cursor(g_win.win, {2,0})
    win.keymaps(g_win.buf,'i', mappings)
    vim.api.nvim_feedkeys("i", "n", false)
end

return M
