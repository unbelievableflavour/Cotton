local gfx<const> = playdate.graphics

class("PlayerBase", {
    isFrozen = false,
    sprite = nil
}).extends()

function PlayerBase:Init()
end

function PlayerBase:update()
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
