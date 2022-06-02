local gfx <const> = playdate.graphics

import "CoreLibs/animation"

class(
    "PagesIcon",
    {
        positionX = 0,
        positionY = 0,
        tileSize = 16 / config.renderScale
    }
).extends(gfx.sprite)

function PagesIcon:init(positionX, positionY, zIndex)
    self.zIndex = zIndex or 0
    local topLeftCorner = getTopLeftCorner()

    self:moveTo(
        topLeftCorner.x + positionX + (self.tileSize / 2),
        topLeftCorner.y + positionY + (self.tileSize / 2)
    )
    self.promptImage = gfx.image.new(config.interface.images.pages, self.tileSize, self.tileSize)
    self:setZIndex(30001 + self.zIndex)
    self:setImage(self.promptImage)
end
