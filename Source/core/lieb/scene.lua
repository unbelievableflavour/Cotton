--[[
	simple scene management
	similar to state.lua but less flexible and more features

	Scene stack (easy to add and go back to previous scene)
	Overlay system (when current scene is an overlay, previous scene snapshot is still render under it)

	functions called on scene objects
	.init()
	.shutdown()
	.resume()
]] --

local gfx <const> = playdate.graphics

import "core/lieb/call"

scene = {
	isCutScene = false
}

-- private members
local _index = 0
local _stack = table.create(8, 0)
local _overlay_background = table.create(8, 0)
local _call_init = false
local _call_init_args = nil

-- push a new scene in the stack
function scene.push(newScene, ...)
	if not newScene then
		return
	end

	if _stack[_index] and scene.isCutScene == false then
		call(_stack[_index].shutdown)
	end

	_index = _index + 1
	_stack[_index] = newScene
	_overlay_background[_index] = nil

	-- we enter a new mode so we will initialize it at the beginning of the next update
	_call_init = true
	_call_init_args = { ... }
end

-- push a new scene in the stack as an overlay
-- draw previous mode as background
function scene.pushOverlay(newScene, ...)
	if not newScene then
		return
	end

	scene.push(newScene, ...)
	_overlay_background[_index] = gfx.getDisplayImage()
end

-- go back to the previous mode in the stack
function scene.back(...)
	if _index <= 1 then
		return
	end

	call(_stack[_index].shutdown)
	_index = _index - 1
	call(_stack[_index].resume, ...)
end

function scene.backTo(gotoScene, ...)
	while _index > 1 and _stack[_index] ~= gotoScene do
		call(_stack[_index].shutdown)
		_index = _index - 1
	end

	call(_stack[_index].resume, ...)
end

-- reset the whole stack
function scene.set(newScene, ...)
	if not newScene then
		return
	end

	for sceneIndex = _index, 1, -1 do
		call(_stack[sceneIndex].shutdown)
	end

	_index = 0
	scene.push(newScene, ...)
end

-- properly switch mode at the beginning of the frame
function scene.update(...)
	-- define at the start of the update so that we deal with the same _index throughout (in case _index is change during the update)
	local updateScene = _stack[_index]
	local updateOverlayBackground = _overlay_background[_index]

	if not updateScene then
		print("lieb/scene.lua: No valid scene to update")
		return
	end

	-- we call the init before it's own update
	if _call_init then
		call(updateScene.init, table.unpack(_call_init_args))
		_call_init = false
	end

	-- render the framebuffer copy of the previous mode
	if updateOverlayBackground then
		updateOverlayBackground:draw(0, 0)

		-- TODO we should abstract that (callback?)
		gfx.setColor(gfx.kColorBlack)
		gfx.setDitherPattern(0.5)
		gfx.fillRect(0, 0, 400, 240)
	end

	-- update the current mode
	call(updateScene.update, ...)
end

function scene.isInStack(checkScene)
	for i = _index, 1, -1 do
		if _stack[i] == checkScene then
			return true
		end
	end

	return false
end

function scene.startCutScene(comicData, afterCutScene)
	local function callbackAfterPanels()
		scene.isCutScene = false
		afterCutScene()
	end

	scene.isCutScene = true
	Panels.startCutscene(comicData, callbackAfterPanels)
	scene.pushOverlay(Panels)
end
