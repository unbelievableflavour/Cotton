local gfx <const> = playdate.graphics

import "CoreLibs/animation"

class(
    "PagesIcon",
    {
        positionX = 0,
        positionY = 0
    }
).extends(gfx.sprite)

function PagesIcon:init(positionX, positionY)
    local topLeftCorner = getTopLeftCorner()

    self:moveTo(topLeftCorner.x + positionX + (16 / 2),topLeftCorner.y +  positionY + (16 / 2))

    self.promptImage = gfx.image.new("images/interface/pages-16-16.png", 16, 16)
    self:setZIndex(32767)
    self:setImage(self.promptImage)
end
