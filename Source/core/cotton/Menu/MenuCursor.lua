class("MenuCursor", {positionX = 0, positionY = 0, selected = 1}).extends(gfx.sprite)

function MenuCursor:init(positionX, positionY)
    self.positionX = positionX
    self.positionY = positionY
    self.tileSize = 16

    self:moveTo(positionX + (self.tileSize / 2), positionY + (self.tileSize / 2))

    self.promptImage = gfx.image.new("images/interface/cursor-active-16-16.png", self.tileSize, self.tileSize)
    self:setZIndex(32767)
    self:setImage(self.promptImage)
end

function MenuCursor:moveUp()
    if self.selected == 1 then
        self:moveToBottom()
        return
    end
    self.selected = self.selected - 1
    self:moveBy(0, -self.tileSize)
end

function MenuCursor:setNumberOfLines(lines)
    self.numberOfLines = lines
    while self.selected > lines do
        self:moveUp()
    end
end

function MenuCursor:moveDown()
    if self.selected == self.numberOfLines then
        self:moveToTop()
        return
    end
    self.selected = self.selected + 1
    self:moveBy(0, self.tileSize)
end

function MenuCursor:moveToBottom()
    while self.selected < self.numberOfLines do
        self:moveDown()
    end
end

function MenuCursor:moveToTop()
    while self.selected > 1 do
        self:moveUp()
    end
end
