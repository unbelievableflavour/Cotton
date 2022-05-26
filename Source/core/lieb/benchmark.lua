local now = playdate.getCurrentTimeMilliseconds

function benchmarkFunction( fn, iteration )
	iteration = iteration or 1
	local start = now()
	for i = 1, iteration do
		fn()
	end

	return now() - start
end

local _startTimestamp
function benchmarkStart()
	_startTimestamp = now()
end

function benchmarkEnd()
	return now() - _startTimestamp
end