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

function detectInput()
    if input.onCrankDock() then
        cotton.player:dock()
    end
    if input.onCrankUndock() then
        cotton.player:undock()
    end
end

function playdate.update()
    hot_import_update()

    input.update()
    detectInput()

    scene.update()
    if config.showFPS then
        playdate.drawFPS()
    end
end
