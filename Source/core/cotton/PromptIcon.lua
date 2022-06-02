local gfx <const> = playdate.graphics

import "CoreLibs/animation"

class("PromptIcon", {
    positionX = 0,
    positionY = 0,
    tileSize = 16
}).extends(gfx.sprite)

function PromptIcon:init(positionX, positionY, zIndex)
    self.zIndex = zIndex or 0

    local imagetable = gfx.imagetable.new(config.interface.images.prompt)
    self.animation = gfx.animation.loop.new(200, imagetable)

    local topLeftCorner = getTopLeftCorner()
    self:moveTo(
        topLeftCorner.x + positionX + (self.tileSize / 2),
        topLeftCorner.y + positionY + (self.tileSize / 2)
    )
    self:setZIndex(30001 + self.zIndex)

    self.promptImage = gfx.image.new(self.tileSize, self.tileSize)
    self:setImage(self.promptImage)
end

function PromptIcon:draw(x, y)
    gfx.pushContext(self.promptImage)
    self.animation:draw(0, 0)
    gfx.popContext()
end

function PromptIcon:remove(x, y)
    -- a small hack for making sure prompt doesnt render anymore
    self:setImage(nil)
    PromptIcon.super.remove(self)
end
