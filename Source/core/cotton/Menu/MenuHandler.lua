local gfx <const> = playdate.graphics

import "./PagesIcon"
import "./MenuCursor"
import "./MenuOptions"

class("MenuHandler", {
    options = {},
    currentChunk = 1
}).extends()

function MenuHandler:init(options, callback)
    game.freeze()
    dialogDepth = dialogDepth + 1

    self.callback = callback or nil

    self.dialogWidth = options.w or 300
    self.dialogHeight = options.h or 98

    self.positionX = options.x or 50
    self.positionY = options.y or 50
    self.margin = 16

    self.dialog = Dialog(self.positionX, self.positionY, self.dialogWidth, self.dialogHeight)
    self.dialog:add()

    self.menuOptions = MenuOptions(self.positionX + self.margin, self.positionY, self.dialogWidth - self.margin,
        self.dialogHeight)
    self.menuOptions:add()

    self.textFont = gfx.font.new("fonts/" .. config.font)
    self.textFontHeight = self.textFont:getHeight()
    self.numberOfLines = math.floor((self.dialogHeight - (self.margin * 2)) / self.textFontHeight)
    self.options = options.options
    self.chunks = self:splitIntoChunksBasedOnNumberOfLines(self.numberOfLines)

    self.cursor = MenuCursor(self.positionX + self.margin, self.positionY + self.margin)
    self.cursor:setNumberOfLines(#self.chunks[self.currentChunk])
    self.cursor:add()

    self.pagesIcon = PagesIcon(self.positionX + self.dialogWidth - self.margin * 2,
        self.positionY + self.dialogHeight - self.margin)

    if #self.chunks > 1 then
        self.pagesIcon:add()
    end

    gfx.setFont(self.textFont)
    self:refreshMenu()
end

function MenuHandler:refreshMenu()
    self.menuOptions:drawOptions(self.chunks[self.currentChunk], self.textFontHeight)
end

function MenuHandler:detectInput()
    if input.justPressed(buttonLeft) then
        self:previousChunkPage()
        self.cursor:setNumberOfLines(#self.chunks[self.currentChunk])
        return
    end

    if input.justPressed(buttonRight) then
        self:nextChunkPage()
        self.cursor:setNumberOfLines(#self.chunks[self.currentChunk])
        return
    end

    if input.justPressed(buttonUp) then
        self.cursor:moveUp()
        return
    end

    if input.justPressed(buttonDown) then
        self.cursor:moveDown()
        return
    end

    if input.justPressed(buttonA) then
        self.chunks[self.currentChunk][self.cursor.selected].callback()
        self:tryClose()
        return
    end

    if input.justPressed(buttonB) then
        if not config.allowDismissRootMenu then
            return
        end
        self:tryClose()
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

function MenuHandler:tryClose()
    self:disableDialog()
    if self.afterClose ~= nil then
        self.afterClose()
    end
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
    self.dialog:remove()
    self.pagesIcon:remove()
    self.cursor:remove()
    self.menuOptions:remove()

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
