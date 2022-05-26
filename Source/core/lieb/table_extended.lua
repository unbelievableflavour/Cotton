local _tableMetatable = {
	__index = table
}

--[[
	Create a new table but with a metatable to use function directly on the table itself
	newTable = table.new( {"foo", "bar"} )
	newTable:insert("foorbar")

	can be also preallocated for performance
	newTable = table.new(arrayCount, hashCount)
]]--
function table.new( arg1, arg2 )
	local o = arg1 or {}
	if type(arg1)=="number" then
		o = table.create(arg1, arg2)
	end
	return setmetatable( o, _tableMetatable)
end

-- insert a new element if it is unique (i.e. the same object)
function table.insertUnique( t, o)
	-- specific to playdate SDK
	if table.indexOfElement( t, o)==nil then
		table.insert( t, o)
		return true
	end

	return false
end

function table.first( t )
    return t[1]
end

function table.last( t )
    return t[#t]
end

function table.random( t )
	if type(t)~="table" then return nil end
    return t[math.ceil(math.random(#t))]
end

function table.each( t, fn )
	if not fn then return end

	for _, e in pairs(t) do
		fn(e)
	end
end

-- remove all elements of the table
-- slower than assigning a new empty table, but avoid trashing the memory
function table.reset( t )
	for key, value in pairs(t) do
		t[key] = nil
	end
end
