local gfx <const> = playdate.graphics

class("TextImage", {
    positionX = 0,
    positionY = 0,
    dialogWidth = 0,
    dialogHeight = 0
}).extends(gfx.sprite)

function TextImage:init(positionX, positionY, textWidth, textHeight, zIndex)
    self.zIndex = zIndex or 0
    self.positionX = positionX
    self.positionY = positionY
    self.dialogWidth = textWidth
    self.dialogHeight = textHeight

    local topLeftCorner = getTopLeftCorner()
    self:moveTo(topLeftCorner.x + self.positionX + (self.dialogWidth / 2),
        topLeftCorner.y + self.positionY + (self.dialogHeight / 2))

    self.textImage = gfx.image.new(self.dialogWidth, self.dialogHeight)

    self:setZIndex(30000 + self.zIndex)

    self:setImage(self.textImage)
end

function TextImage:drawText(text, x, y)
    gfx.pushContext(self.textImage)
    cotton.textFont:drawText(text, x, y, self.dialogWidth, self.dialogHeight)
    gfx.popContext()
end

function TextImage:clean()
    self.textImage = gfx.image.new(self.dialogWidth, self.dialogHeight)
    self:setImage(self.textImage)
end
