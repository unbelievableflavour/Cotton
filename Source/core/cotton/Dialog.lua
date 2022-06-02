local gfx <const> = playdate.graphics

class("Dialog", {
    positionX = 0,
    positionY = 0,
    dialogWidth = 0,
    dialogHeight = 0
}).extends(gfx.sprite)

function Dialog:init(positionX, positionY, dialogWidth, dialogHeight, zIndex)
    self.zIndex = zIndex or 0
    self.positionX = positionX
    self.positionY = positionY
    self.dialogWidth = dialogWidth
    self.dialogHeight = dialogHeight

    local topLeftCorner = getTopLeftCorner()
    self:moveTo(topLeftCorner.x + self.positionX + (self.dialogWidth / 2),
        topLeftCorner.y + self.positionY + (self.dialogHeight / 2))

    local nineslice = gfx.nineSlice.new(
        config.interface.images.dialog,
        10 / config.gridRenderScale,
        10 / config.gridRenderScale,
        1, 1
    )
    self.dialogImage = gfx.image.new(self.dialogWidth, self.dialogHeight)

    gfx.pushContext(self.dialogImage)
    nineslice:drawInRect(0, 0, self.dialogWidth, self.dialogHeight)
    gfx.popContext()

    self:setZIndex(30000 + self.zIndex)

    self:setImage(self.dialogImage)
end
