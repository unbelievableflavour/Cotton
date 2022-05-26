--[[
Simple State class
Useful to manage different screens, scenes or modes

The state can be set to a lua object:
currentScreen = new( state, intro )
currentScreen:set( gameOver )

Properties and function of the object can be directly access with the state object
currentScreen.update()
currentScreen.quit()
currentScreen.property

By default when a property is missing, it returns an empty function.
It enables to call functions without triggering an error even if they are not all defined in all objects use as state

However if a number is not defined or nil it will also return a function, in this case it is better to use get() to access the raw object
currentScreen.missingProperty > will return an empty function
currentScreen.get().missingProperty > will return nil
]]--

state = {}
state.__index = function(self, key)
	-- if this is a standard key in the state class, we simply return it
	if state[key] then return state[key] end

	-- check if we should get a property of the current state
	-- can return an empty function if the property is not defined
	-- (as it lets the user call a function even if the property is not defined)
	if type(self.current)=="table" then
		return self.current[key] or function() end
	end

	return nil
end

-- create a new state
-- @current_state: initial state (can be any type of value)
function state.new(current_state)
	return setmetatable({
		current = current_state
	}, state)
end

function state:set(state)
	self.current = state
end

function state:get()
	return self.current
end

function state:is(state)
	return self.current==state
end