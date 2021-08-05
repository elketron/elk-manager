local api = vim.api
local buf, win
local position = 0
local num = 0

local M = {}

todo_seperator = "|"

local function center(str)
  local width = api.nvim_win_get_width(0)
  local shift = math.floor(width / 2) - math.floor(string.len(str) / 2)
  return string.rep(' ', shift) .. str
end
local function win_title(title)
  -- we can add title already here, because first line will never change
  api.nvim_buf_set_lines(buf, 0, -1, false, { center(title), '', ''})
  api.nvim_buf_add_highlight(buf, -1, 'WhidHeader', 0, 0, -1)
end
function M.open_window()
  buf = api.nvim_create_buf(false, true)
  local border_buf = api.nvim_create_buf(false, true)

  api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
  api.nvim_buf_set_option(buf, 'filetype', 'whid')

  local width = api.nvim_get_option("columns")
  local height = api.nvim_get_option("lines")

  local win_height = math.ceil(height * 0.8 - 4)
  local win_width = math.ceil(width * 0.8)
  local row = math.ceil((height - win_height) / 2 - 1)
  local col = math.ceil((width - win_width) / 2)

  local border_opts = {
    style = "minimal",
    relative = "editor",
    width = win_width + 2,
    height = win_height + 2,
    row = row - 1,
    col = col - 1
  }

  local opts = {
    style = "minimal",
    relative = "editor",
    width = win_width,
    height = win_height,
    row = row,
    col = col
  }

  local border_lines = { '╔' .. string.rep('═', win_width) .. '╗' }
  local middle_line = '║' .. string.rep(' ', win_width) .. '║'
  for i=1, win_height do
    table.insert(border_lines, middle_line)
  end
  table.insert(border_lines, '╚' .. string.rep('═', win_width) .. '╝')
  api.nvim_buf_set_lines(border_buf, 0, -1, false, border_lines)

  local border_win = api.nvim_open_win(border_buf, true, border_opts)
  win = api.nvim_open_win(buf, true, opts)
  api.nvim_command('au BufWipeout <buffer> exe "silent bwipeout! "'..border_buf)

  api.nvim_win_set_option(win, 'cursorline', true) -- it highlight line with the cursor on it

  win_title("Groups")
end

local function print_arr(todos)
  local s = ""
  local out = {}
    for key, val in next,todos,nil do
        for k,v in next,val,nil do
          for i = 1, #v,1 do
            s = s..todo_seperator..v[i]
          end
          table.insert(out,s)
          s = ""
        end
    end
    return out
end

local function groups(todos)
  local out = {}
  for key,val in pairs(todos) do
    table.insert(out,key)
  end
  return out
end

local function update(todo)
  local out = {}
  if num == 0 then
    out = groups(todo)
  elseif num == 2 then
    out = print_arr(todo)
  end

  vim.api.nvim_buf_set_lines(buf,0,-1,false,out)
end

local function add_to_num(to_add)
  num = num + to_add
end

local function close_window()
  api.nvim_win_close(win, true)
end

local function key_maps()
  local mappings = {
    ['<cr>'] = 'update()',
    j = 'add_to_num(1)',
    k = 'add_to_num(-1)'
  }
end


return M
