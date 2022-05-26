--[[
call a function that might not be assigned
for example for callbacks

call( entity.applyDamage, 5 )
]]--

function call( fn, ...)
	if type(fn)=="function" then
		fn(...)
	end
end