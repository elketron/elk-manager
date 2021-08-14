local utils = require"elk-manager.utils.utils"
local json = require"elk-manager.utils.json"
local jio = require"elk-manager.json_io"

local M = {}

default_file_path="~/Projects/elk-manager/temps/"

local data = {}
local temp_vars = {"$name", "$folder", "$path", "$full_path"} 

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

local function find_relative_path(path)
    local s = "ls -a "

    for i = 1, #path,1 do
        s = s .. "../"
        rel = vim.api.nvim_exec(":!" .. s,true)
        local j,k = string.find(rel, "%.proj")
        print(i,#path)
    
        if j ~= nil and k ~= nil then
            local str = ""
        
            for v = #path,i + 2,-1 do
               str =  path[v].. "/" ..str
            end
            print(str)
            return str 
        end
    end
    return ""
end

local function change_file_content(key,dir,ext)
    local path = vim.api.nvim_exec('pwd',true)
    vim.api.nvim_command("edit ".. dir .. "/" .. key .. "." ..  ext)
    local line_count = vim.api.nvim_buf_line_count(0)
    
    for i = 0, line_count - 1, 1 do
       line = vim.api.nvim_buf_get_lines(0, i,i + 1,false ) 
       
       for  _,v in ipairs(temp_vars) do
           local k,j = string.find(line[1], v)
            
           if k ~= nil and j ~= nil then
               if v == "$name" then
                   s = {string.sub(line[1],1,k - 1) .. key .. string.sub(line[1],j + 1, #line[1])} 

               elseif v == "$folder" then
                   current_folder = utils.split(path,"/") 
                   s = {string.sub(line[1],1,k - 1) .. current_folder[#current_folder] .. string.sub(line[1],j + 1, #line[1])} 
                
               elseif v == "$path" then 
                   local p = find_relative_path(utils.split(path,"/"))
                   s = {string.sub(line[1],1,k - 1) .. p .. string.sub(line[1],j + 1, #line[1])} 
                
               elseif v == "$full_path" then
                   s = {string.sub(line[1],1,k - 1) .. path .. string.sub(line[1],j + 1, #line[1])} 
               end
               vim.api.nvim_buf_set_lines(0,i,i + 1,false,s)
           end
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
    moved = vim.api.nvim_exec(":! cp " .. data[key][1] .. " " ..dir.."/"..name.."."..string.sub(ext[2],1,#ext[2]), true)
    
    change_file_content(name,dir,ext[2])
    return moved
end

function M.write(file)
    jio.write(file)
end

function M.read(file)
    jio.read(file)
end

return M
