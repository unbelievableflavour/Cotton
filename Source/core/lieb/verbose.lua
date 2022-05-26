verbose = {}

local _empty_function = function() end

function verbose.print()
end

function verbose.on( condition, topic )
	if not condition then
		verbose.off()
		return
	end

	print("\nVERBOSE ON:", topic)
	verbose.print = function(...) printT(...) end
end

function verbose.off()
	verbose.print = _empty_function
end
