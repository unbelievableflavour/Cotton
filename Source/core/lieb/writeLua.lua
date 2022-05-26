-- TODO, reference tables
-- TODO check for depth limit

local function _isArray( t )
	if type(t[1])=="nil" then return false end

	local pairs_count = 0
	for key in pairs(t) do
		pairs_count = pairs_count + 1
		if type(key)~="number" then
			return false
		end
	end

	return pairs_count==#t
end

function writeLua( filepath, table_to_export )
	assert( filepath, "writeLua, filepath required")
	assert( table_to_export, "writeLua, table_to_export required")

	local file, file_error = playdate.file.open(filepath, playdate.file.kFileWrite)
	assert(file, "writeLua, Cannot open file",filepath," (",file_error,")")

	local _write_entry
	_write_entry = function( entry, name )
		local entry_type = type(entry)

		if entry_type=="table" then
			file:write("{")
			if _isArray( entry ) then
				for key, value in ipairs(entry) do
					_write_entry(value, key)
					file:write(",")
				end
			else
				for key, value in pairs(entry) do
					file:write("[\""..tostring(key).."\"]=")
					_write_entry(value, key)
					file:write(",")
				end
			end
			file:write("}")
		elseif entry_type=="string" then
			file:write("\""..tostring(entry).."\"")
		elseif entry_type=="boolean" or entry_type=="number" then
			file:write(tostring(entry))
		else
			file:write("nil")
		end
	end

	file:write("return ")
	_write_entry( table_to_export )

	file:close()
end

