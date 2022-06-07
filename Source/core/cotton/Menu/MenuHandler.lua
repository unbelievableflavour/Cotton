local gfx <const> = playdate.graphics

import "core/cotton/Menu/PagesIcon"
import "core/cotton/Menu/MenuCursor"
import "core/cotton/Menu/MenuOptions"

class("MenuHandler", {
    options = {},
    currentChunk = 1,
    margin = 16 / config.renderScale
}).extends()

dialogDepth = 0
subMenu = {}

function MenuHandler:init(options, callback)
    dialogDepth = dialogDepth + 1
    subMenu[dialogDepth] = self

    game.freeze()

    self.callback = callback or nil

    local fontSize = cotton.textFontHeight
    local maxWidthForOption = getMaxWidthForOptions(options.options, fontSize)
    local menuDialogWidth = maxWidthForOption + self.margin * 2

    self.dialogWidth = options.w or (menuDialogWidth)
    self.dialogHeight = options.h or (96 / config.renderScale) -- 96 = 6 tilerows (4 text + 2 margin rows)

    self.positionX = options.x or (50 / config.renderScale)
    self.positionY = options.y or (50 / config.renderScale)

    self.zIndex = options.zIndex or 0

    self.dialog = Dialog(
        self.positionX,
        self.positionY,
        self.dialogWidth,
        self.dialogHeight,
        dialogDepth + self.zIndex
    )
    self.dialog:add()
    self.menuOptions = MenuOptions(
        self.positionX + self.margin,
        self.positionY, self.dialogWidth - self.margin,
        self.dialogHeight,
        dialogDepth + self.zIndex
    )
    self.menuOptions:add()

    self.numberOfLines = math.floor((self.dialogHeight - (self.margin * 2)) / cotton.textFontHeight)
    self.options = options.options
    self.chunks = self:splitIntoChunksBasedOnNumberOfLines(self.numberOfLines)

    self.cursor = MenuCursor(
        self.positionX + self.margin,
        self.positionY + self.margin,
        dialogDepth + self.zIndex
    )
    self.cursor:setNumberOfLines(#self.chunks[self.currentChunk])
    self.cursor:add()

    self.pagesIcon = PagesIcon(
        self.positionX + self.dialogWidth - self.margin * 2,
        self.positionY + self.dialogHeight - self.margin,
        dialogDepth + self.zIndex
    )

    if #self.chunks > 1 then
        self.pagesIcon:add()
    end

    gfx.setFont(cotton.textFont)
    self:refreshMenu()
    cotton.game:change()
end

function MenuHandler:refreshMenu()
    self.menuOptions:drawOptions(self.chunks[self.currentChunk], cotton.textFontHeight)
end

function MenuHandler:detectInput()
    if input.justPressed(buttonLeft) then
        cotton.game:change()
        self:previousChunkPage()
        self.cursor:setNumberOfLines(#self.chunks[self.currentChunk])
        return
    end

    if input.justPressed(buttonRight) then
        cotton.game:change()
        self:nextChunkPage()
        self.cursor:setNumberOfLines(#self.chunks[self.currentChunk])
        return
    end

    if input.justPressed(buttonUp) then
        cotton.game:change()
        self.cursor:moveUp()
        return
    end

    if input.justPressed(buttonDown) then
        cotton.game:change()
        self.cursor:moveDown()
        return
    end

    if input.justPressed(buttonA) then
        if self.chunks[self.currentChunk][self.cursor.selected].type == "submenu" then
            self.chunks[self.currentChunk][self.cursor.selected].callback()
        else
            self:tryCloseAll()
            self.chunks[self.currentChunk][self.cursor.selected].callback()
        end
        cotton.game:select()
        return
    end

    if input.justPressed(buttonB) then
        self:tryClose(buttonB)
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

function MenuHandler:tryClose(button)
    if self:isRootMenu() and config.allowDismissRootMenu == false and button == buttonB then
        return
    end

    if self:isRootMenu() then
        cotton.keyListener:unsetKeyListener()
    else
        cotton.keyListener:setCurrentKeyListener(
            function() subMenu[dialogDepth]:detectInput() end
        )
    end

    dialogDepth = dialogDepth - 1
    self:disableDialog()
    cotton.game:dismiss()
end

function MenuHandler:tryCloseAll()
    cotton.keyListener:unsetKeyListener()
    self:disableDialog()
    while dialogDepth > 1 do
        dialogDepth = dialogDepth - 1
        subMenu[dialogDepth]:disableDialog()
    end
    dialogDepth = 0
    subMenu = {}

    game.unfreeze()
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

    if type(self.callback) == "function" then
        self.callback()
    end

    if dialogDepth == 0 then
        game.unfreeze()
    end
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

function MenuHandler:isRootMenu()
    return dialogDepth == 1
end
