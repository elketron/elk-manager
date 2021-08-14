local api = vim.api
local win
local position = 0
local M = {}


todo_seperator = "|"

function M.print(buf,inp)
  vim.api.nvim_buf_set_lines(buf,0,-1,false,inp)
end

local function center(str)
  local width = api.nvim_win_get_width(0)
  local shift = math.floor(width / 2) - math.floor(string.len(str) / 2)
  return string.rep(' ', shift) .. str
end

function M.win_title(buf,title)
  -- we can add title already here, because first line will never change
  api.nvim_buf_set_lines(buf, 0, 1, false, { center(title), '', ''})
  api.nvim_buf_add_highlight(buf, 1, 'WhidHeader', 0, 0, -1)
end

local options = {
  w_width = 95,
  w_height = 95,
  w_row = 100,
  w_col = 100
}

function M.open_window(settings)
  if settings ~= nil then
    options = settings
  end

  buf = api.nvim_create_buf(true, true)
  local border_buf = api.nvim_create_buf(false, true)

  api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')

  local width = api.nvim_get_option("columns")
  local height = api.nvim_get_option("lines")

  local win_height = math.ceil(options.w_height / 100 * (height * 0.8 - 4))
  local win_width = math.ceil(options.w_width / 100 * (width * 0.8))
  local row = math.ceil((height - win_height) * (options.w_row / 100) - 1)
  local col = math.ceil((width - win_width) * (options.w_col / 100))
  print(win_height,win_width,row,col)

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

  local border_lines = { '┌' .. string.rep('─', win_width) .. '┐' }
  local middle_line = '│' .. string.rep(' ', win_width) .. '│'
  for i=1, win_height do
    table.insert(border_lines, middle_line)
  end
  table.insert(border_lines, '└' .. string.rep('─', win_width) .. '┘')
  api.nvim_buf_set_lines(border_buf, 0, -1, false, border_lines)

  local border_win = api.nvim_open_win(border_buf, true, border_opts)
  win = api.nvim_open_win(buf, true, opts)
  api.nvim_command('au BufWipeout <buffer> exe "silent bwipeout! "'..border_buf)

  api.nvim_win_set_option(win, 'cursorline', true) -- it highlight line with the cursor on it

  return {
    width = width,
    height = height,
    buf = buf,
    win = win
  }
end

function M.close_window(win)
  api.nvim_win_close(win, true)
end

function M.keymaps(buf,mode,mappings)
  for k,v in pairs(mappings) do
    vim.api.nvim_buf_set_keymap(buf,mode, k, '<cmd>lua require'..v..'<cr>', {
      nowait = true, noremap = true, silent = true
      })
  end
end

function M.move_cursor(win)
  local new_pos = math.max(4, api.nvim_win_get_cursor(win)[1])
  api.nvim_win_set_cursor(win, {new_pos, 0})
end

return M
