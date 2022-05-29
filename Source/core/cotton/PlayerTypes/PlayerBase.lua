local gfx <const> = playdate.graphics

class("PlayerBase", {
    isFrozen = false,
    sprite = nil
}).extends()

function PlayerBase:Init()
end

function PlayerBase:update()
end

function PlayerBase:doBasicInputChecks()
    if input.justPressed(buttonA) then
        cotton.player:confirmPressed()
    end

    if input.justReleased(buttonA) then
        cotton.player:confirmReleased()
    end

    if input.justPressed(buttonB) then
        cotton.player:cancelPressed()
    end

    if input.justReleased(buttonB) then
        cotton.player:cancelReleased()
    end

    if input.onCrankDock() then
        cotton.player:dock()
    end

    if input.onCrankUndock() then
        cotton.player:undock()
    end

    if input.isCranking() then
        cotton.player:crank()
    end
end

function PlayerBase:isAtNorthScreenEdge()
    return self.sprite.y < 0
end

function PlayerBase:isAtEastScreenEdge()
    return self.sprite.x + self.sprite.width > screenWidth
end

function PlayerBase:isAtSouthScreenEdge()
    return self.sprite.y + self.sprite.height > screenHeight
end

function PlayerBase:isAtWestScreenEdge()
    return self.sprite.x < 0
end

function PlayerBase:freeze()
    self.isFrozen = true
end

function PlayerBase:unfreeze()
    self.isFrozen = false
end
