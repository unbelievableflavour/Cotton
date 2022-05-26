class(
    "MenuOptions",
    {
        positionX = 0,
        positionY = 0,
        dialogWidth = 0,
        dialogHeight = 0,
        margin = 16
    }
).extends(gfx.sprite)

function MenuOptions:init(positionX, positionY, dialogWidth, dialogHeight)
    self.positionX = positionX
    self.positionY = positionY
    self.dialogWidth = dialogWidth
    self.dialogHeight = dialogHeight

    self:moveTo(positionX + (self.dialogWidth / 2), positionY + (self.dialogHeight / 2))

    self.optionsImage = gfx.image.new(self.dialogWidth, self.dialogHeight)

    self:setZIndex(32767)
    self:setImage(self.optionsImage)
end

function MenuOptions:drawOptions(chunkOfOptions, textFontHeight)
    local lineLoopIndex = 0

    local textPositionX = self.positionX + self.margin
    local textPositionY = self.positionY + self.margin

    self.optionsImage = gfx.image.new(self.dialogWidth, self.dialogHeight)

    gfx.pushContext(self.optionsImage)
    for key, option in pairs(chunkOfOptions) do
        gfx.drawTextInRect(
            option.name,
            0 + self.margin,
            0 + self.margin + (textFontHeight * lineLoopIndex),
            self.dialogWidth - self.margin,
            textFontHeight
        )
        lineLoopIndex = lineLoopIndex + 1
    end
    gfx.popContext()
    self:setImage(self.optionsImage)
end
