import "CoreLibs/graphics"
import "CoreLibs/object"
import "CoreLibs/sprites"
import "CoreLibs/nineslice"
import "CoreLibs/timer"

import "config"

import "core/definitions"
import "core/cotton/all"

import "scripts/index"

import "core/lieb/all"
import "core/CoreGame"

playdate.display.setRefreshRate(30)

playdate.display.setScale(config.renderScale)
LDtk.load("levels/world.ldtk", shouldUseFastLoader())

if playdate.isSimulator then
    LDtk.export_to_lua_files()
end

scene.set(game, LDtk.playerStartLocation)

function playdate.update()
    input.update()

    scene.update()
    if config.showFPS then
        playdate.drawFPS()
    end

    playdate.timer.updateTimers()
end
