--[[
assign an index number to each key
layers = enum({
	"background",
	"enemies",
	"player",
	"clouds"
})
sprite:setZIndex(layer.player)
]]--

function enum( t, readonly )
	local result = {}

	for index, name in pairs(t) do
		result[name] = index
	end

	if readonly==false then
		return result
	end

	-- setup the table to be read only
	return setmetatable({}, {
		__index = result,
		__newindex = function(table, key, value)
				error(key.." is a read only enum value", 2)
			end,
		__metatable = false
	})
end