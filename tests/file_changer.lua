local function file_changer(name)
    file_name = "test"
    vim.api.nvim_command("edit ".. name)
    local line_count = vim.api.nvim_buf_line_count(0)
    print(line_count)
    
    for i = 0, line_count - 1, 1 do
       line = vim.api.nvim_buf_get_lines(0, i,i + 1,false ) 
       print(line[1])
       k,j = string.find(line[1],"$name")

       if k ~= nil and j ~= nil then
           print(i,k,j)
           s = {string.sub(line[1],1,k - 1) .. file_name .. string.sub(line[1],j + 1, #line[1])} 
           vim.api.nvim_buf_set_lines(0,i,i + 1,false,s)
       end
        
    end


end

file_changer("test.hpp")
