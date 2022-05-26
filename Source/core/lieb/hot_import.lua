--[[
	hot reload lua scripts when running the game in the simulator
]]--

local _imports = {}

local function load_hot_import( filepath, ... )
	local callback = playdate.file.run( filepath )

	if type(callback)=="function" then
		print( "callback", filepath, ...)
		callback( filepath, ... )
	end
end

function hot_import( importName )
	local filepath = importName..'.pdz'

	if not playdate.file.exists( filepath ) then
		error( importName .. "doesn't exist", 2)
		return
	end

	print( 'hot_import: initial load for '..importName)
	load_hot_import( importName, "init" )

	_imports[ importName ] = {
		filepath = filepath,
		modtime = playdate.file.modtime( filepath )
	}
end

local _lastCheckTimestamp = nil
local _checkCooldown = 1
function hot_import_update()
	local now = playdate.getCurrentTimeMilliseconds()
	_lastCheckTimestamp = _lastCheckTimestamp or now

	if ( now - _lastCheckTimestamp ) < _checkCooldown then
		return
	end

	for importName, importEntry in pairs(_imports) do
		local modtime = playdate.file.modtime( importEntry.filepath )

		-- check if we need to reload
		if not (
			modtime.year==importEntry.modtime.year and
			modtime.month==importEntry.modtime.month and
			modtime.day==importEntry.modtime.day and
			modtime.hour==importEntry.modtime.hour and
			modtime.minute==importEntry.modtime.minute and
			modtime.second==importEntry.modtime.second
			) then

			print( 'hot_import: reload '..importName)
			load_hot_import( importName, "reload" )
			importEntry.modtime = modtime
		end
	end
end

if not playdate.isSimulator then
	hot_import = playdate.file.run
	hot_import_update = function() end
end

