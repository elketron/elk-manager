-- split a string into a table
function split(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end

local function print_arr(arr)
    for  _,k in ipairs(arr) do
        print(_,k)
    end
end

local function check_path()
    local test = vim.api.nvim_exec(":! ls -a ../",true)
    local i,j = test:find("%.proj")

    print(test)
    print(i,j)
    --local f = split(path,"/")
    --print_arr(res)
end

--check_path()
--
for i = 10, 5,-1 do 
    print(i)
end
