import "CoreLibs/graphics"
import "CoreLibs/object"
import "CoreLibs/sprites"
import "CoreLibs/nineslice"

import "core/definitions"

import "core/cotton/all"

import "config"
import "scripts/index"

import "core/lieb/all"

import "core/CoreGame"

playdate.display.setRefreshRate(30)

asset.loadImageFolder("images/")

LDtk.load("levels/world.ldtk", config.useFastLoader)

if playdate.isSimulator then
	LDtk.export_to_lua()
end

scene.set(game, "Level_0")

function playdate.update()
	hot_import_update()

	input.update()

	scene.update()
	if config.showFPS then
		playdate.drawFPS()
	end
end
