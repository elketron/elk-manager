local utils = require"utils.utils"
local json = require"utils.json"
local jio = require"json_io"

local M = {}

default_file_path="~/Projects/elk-manager/temps/"

local data = {}

-- adds entry to data
function M.add(key,file_path,type,language)
    data[key] = {default_file_path..file_path,file,type,language}
end

function M.get_data()
    return data
end

function M.get_keys()
    local temp = {}
    for _,k in next, data, nil do
        table.insert(temp,_)
    end
    return temp
end

function M.remove(key)
    data[key] = nil
end

local function change_file_content(key,dir,ext)

    vim.api.nvim_command("edit ".. dir .. "/" .. key .. "." ..  ext)
    local line_count = vim.api.nvim_buf_line_count(0)
    print(key,dir,ext)
    
    for i = 0, line_count - 1, 1 do
       line = vim.api.nvim_buf_get_lines(0, i,i + 1,false ) 
       k,j = string.find(line[1],"$name")

       if k ~= nil and j ~= nil then
           s = {string.sub(line[1],1,k - 1) .. key .. string.sub(line[1],j + 1, #line[1])} 
           vim.api.nvim_buf_set_lines(0,i,i + 1,false,s)
       end
        
    end
end

-- key: data key
-- dir : directory to copy file to
-- name: name to call file
-- returns bool
function M.get_template(key, dir, name)
    local ext = utils.split(data[key][1], "%.")
    ext[2] = string.sub(ext[2],1,#ext + 1)
    moved = io.popen("cp " .. data[key][1] .. " " ..dir.."/"..name.."."..string.sub(ext[2],1,#ext[2]))
    change_file_content(name, dir, ext[2])
    print(key,dir,name)
    return moved
end

function M.write(file)
    jio.write(file)
end

function M.read(file)
    jio.read(file)
end

return M
