local gfx <const> = playdate.graphics

import "CoreLibs/animation"

class("PromptIcon", {
    positionX = 0,
    positionY = 0
}).extends(gfx.sprite)

function PromptIcon:init(positionX, positionY)
    local imagetable = gfx.imagetable.new("images/interface/prompt-table-16-16.png")
    self.animation = gfx.animation.loop.new(200, imagetable)

    local topLeftCorner = getTopLeftCorner()
    self:moveTo(topLeftCorner.x + positionX + (16 / 2), topLeftCorner.y + positionY + (16 / 2))
    self:setZIndex(32767)

    self.promptImage = gfx.image.new(16, 16)
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
