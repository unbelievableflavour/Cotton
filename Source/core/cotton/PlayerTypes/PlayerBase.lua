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

function PlayerBase:isAtNorthRoomEdge()
    return self.sprite.y < 0
end

function PlayerBase:isAtEastRoomEdge()
    return self.sprite.x + self.sprite.width > cotton.room.w
end

function PlayerBase:isAtSouthRoomEdge()
    return self.sprite.y + self.sprite.height > cotton.room.h
end

function PlayerBase:isAtWestRoomEdge()
    return self.sprite.x < 0
end

function PlayerBase:freeze()
    self.isFrozen = true
end

function PlayerBase:unfreeze()
    self.isFrozen = false
end

function PlayerBase:fixCamera()
    local spriteX, spriteY = self.sprite:getPosition()
    gfx.setDrawOffset(screenCenterX - spriteX, screenCenterY - spriteY)
end

function PlayerBase:moveTo(x, y)
    self.sprite:moveTo(x, y)
end

function PlayerBase:readd(x, y)
    self.sprite:add()
    self:moveTo(x, y)
end
