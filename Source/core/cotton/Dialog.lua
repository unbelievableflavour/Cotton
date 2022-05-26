class(
    "Dialog",
    {
        positionX = 0,
        positionY = 0,
        dialogWidth = 0,
        dialogHeight = 0
    }
).extends(gfx.sprite)

function Dialog:init(positionX, positionY, dialogWidth, dialogHeight)
    self.positionX = positionX
    self.positionY = positionY
    self.dialogWidth = dialogWidth
    self.dialogHeight = dialogHeight

    self:moveTo(positionX + (self.dialogWidth / 2), positionY + (self.dialogHeight / 2))
    local nineslice = gfx.nineSlice.new("images/interface/dialog-20-20", 9, 9, 1, 1)
    self.dialogImage = gfx.image.new(self.dialogWidth, self.dialogHeight)

    gfx.pushContext(self.dialogImage)
    nineslice:drawInRect(0, 0, self.dialogWidth, self.dialogHeight)
    gfx.popContext()

    self:setZIndex(32766)

    self:setImage(self.dialogImage)
end
