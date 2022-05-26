local gfx <const> = playdate.graphics

import "./PagesIcon"
import "./MenuCursor"
import "./MenuOptions"

class(
    "MenuHandler",
    {
        options = {},
        currentChunk = 1
    }
).extends()

function MenuHandler:new(x, y, width, height, options)
    game.freeze()
    self.dialogWidth = width or 300
    self.dialogHeight = height or 98

    self.positionX = x or 50
    self.positionY = y or 50
    self.margin = 16

    self.dialog = Dialog(self.positionX, self.positionY, self.dialogWidth, self.dialogHeight)
    self.dialog:add()

    self.menuOptions =
        MenuOptions(self.positionX + self.margin, self.positionY, self.dialogWidth - self.margin, self.dialogHeight)
    self.menuOptions:add()

    self.textFont = gfx.font.new("fonts/" .. config.font)
    self.textFontHeight = self.textFont:getHeight()
    self.numberOfLines = math.floor((self.dialogHeight - (self.margin * 2)) / self.textFontHeight)
    self.options = options
    self.chunks = self:splitIntoChunksBasedOnNumberOfLines(self.numberOfLines)
    self.isActive = true

    self.cursor = MenuCursor(self.positionX + self.margin, self.positionY + self.margin)
    self.cursor:setNumberOfLines(#self.chunks[self.currentChunk])
    self.cursor:add()

    self.pagesIcon =
        PagesIcon(self.positionX + self.dialogWidth - self.margin * 2, self.positionY + self.dialogHeight - self.margin)

    if #self.chunks > 1 then
        self.pagesIcon:add()
    end

    gfx.setFont(self.textFont)
    self:refreshMenu()
end

function MenuHandler:Update()
    if not self.isActive then
        return
    end

    self:detectInput()
end

function MenuHandler:refreshMenu()
    self.menuOptions:drawOptions(self.chunks[self.currentChunk], self.textFontHeight)
end

function MenuHandler:detectInput()
    if playdate.buttonJustPressed(playdate.kButtonLeft) then
        self:previousChunkPage()
        self.cursor:setNumberOfLines(#self.chunks[self.currentChunk])
        return
    end

    if playdate.buttonJustPressed(playdate.kButtonRight) then
        self:nextChunkPage()
        self.cursor:setNumberOfLines(#self.chunks[self.currentChunk])
        return
    end

    if playdate.buttonJustPressed(playdate.kButtonUp) then
        self.cursor:moveUp()
        return
    end

    if playdate.buttonJustPressed(playdate.kButtonDown) then
        self.cursor:moveDown()
        return
    end

    if playdate.buttonJustPressed(playdate.kButtonA) then
        self.chunks[self.currentChunk][self.cursor.selected].callback()
        self:disableDialog()
        return
    end

    if playdate.buttonJustPressed(playdate.kButtonB) then
        if not config.allowDismissRootMenu then
            return
        end
        self:disableDialog()
        return
    end
end

function MenuHandler:nextChunkPage()
    if self.currentChunk == #self.chunks then
        self.currentChunk = 1
        self:refreshMenu()
        return
    end

    self.currentChunk = self.currentChunk + 1
    self:refreshMenu()
end

function MenuHandler:moveCursorUp()
    if self.currentChunk == #self.chunks then
        self.currentChunk = 1
        self:refreshMenu()
        return
    end

    self.currentChunk = self.currentChunk + 1
    self:refreshMenu()
end

function MenuHandler:previousChunkPage()
    if self.currentChunk == 1 then
        self.currentChunk = #self.chunks
        self:refreshMenu()
        return
    end
    self.currentChunk = self.currentChunk - 1
    self:refreshMenu()
end

function MenuHandler:disableDialog()
    self.isActive = false
    self.dialog:remove()
    self.pagesIcon:remove()
    self.cursor:remove()
    self.menuOptions:remove()
    cotton.eventHandler:markEventAsDone()
    game.unfreeze()
end

function MenuHandler:splitIntoChunksBasedOnNumberOfLines(numberOfLines)
    local chunks = {}
    local currentChunk = {}

    local numberOfLinesCurrent = 0
    local totalLoopCount = 0
    for key, option in pairs(self.options) do
        if numberOfLinesCurrent == numberOfLines then
            table.insert(chunks, currentChunk)
            numberOfLinesCurrent = 0
            currentChunk = {}
        end

        currentChunk[numberOfLinesCurrent + 1] = option

        numberOfLinesCurrent = numberOfLinesCurrent + 1
        totalLoopCount = totalLoopCount + 1

        if totalLoopCount == #self.options then
            table.insert(chunks, currentChunk)
            numberOfLinesCurrent = 0
            currentChunk = {}
        end
    end

    return chunks
end
