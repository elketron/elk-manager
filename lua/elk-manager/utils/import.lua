strings = require("useful.strings")
split = strings.split

local function get_module(module)
	local success, result = pcall(require, module)

	if not success then
		error(result:gsub(":.*$", ""))
	end

	return result
end

local function set_global(name, value)
	-- <name> must only contain an identifier.
	local s, e = name:find("[_%a][_%w]*")
	if not (s == 1 and e == #name) then
		print("Error: <name> must be an identifier")
		return
	end
	load(string.format("%s = ...", name))(value)
end

local function import_star(substatement)
	local words = substatement:strip():split(" ")
	if words[2] ~= "from" or #words > 3 then
		error('expected statement of the form "* from <mod>"')
	end

	local module = get_module(words[3])
	
	-- Extract each member from the module into the global
	-- namespace.
	for k, v in pairs(module) do
		set_global(k, v)
	end
end

local function import_individuals(substatement, list_end, mod_begin)
	local module_name = substatement:sub(mod_begin):strip()
	local module = get_module(module_name)
	local items = substatement:sub(1, list_end - 1):strip():split(",")
	
	for _, item in ipairs(items) do
		name, alias = table.unpack(item:strip():split(" as "))
		if alias then
			set_global(alias, module[name])
		else
			set_global(name, module[name])
		end
	end
end

local function import_modules(substatement)
	module_names = substatement:strip():split(",")
	
	for _, item in ipairs(module_names) do
		name, alias = table.unpack(item:strip():split(" as "))
		if alias then
			set_global(alias, get_module(name))
		else 
			set_global(name, get_module(name))
		end
	end
end

local function import(statement)
	assert(type(statement) == 'string', "expected string")	
	local substatements = statement:split(";")

	for _, substatement in ipairs(substatements) do
		substatement = substatement:strip()
		-- import[[* from <module>]]
		if substatement:sub(1,1) == "*" then
			import_star(substatement)
		else
			local first, last = substatement:find(" from ", 1, true)
			if first then
				-- import[[name (as alias), ... from module]]
				import_individuals(substatement, first, last)
			else
				-- import[[module1 (as alias), ...]]
				import_modules(substatement)
			end		
		end
	end
end

return import
