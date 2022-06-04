local gfx <const> = playdate.graphics

import "core/cotton/PromptIcon"
import "core/cotton/TextImage"

class("MessageHandler", {
    options = {},
    isActive = false,
    wordList = {},
    chunkList = {},
    currentLength = 0,
    chunkOffset = 0,
    currentChunk = 0,
    margin = 16 / config.renderScale
}).extends()

function MessageHandler:new(message, options)
    self.dialogDepth = 1
    self.options = options.options
    self.afterClose = options.afterClose

    game.freeze()

    self.dialogWidth = options.w or (300 / config.renderScale)
    self.dialogHeight = options.h or (96 / config.renderScale) -- 96 = 6 tilerows (4 text + 2 margin rows)

    self.positionX = options.x or (50 / config.renderScale)
    self.positionY = options.y or (50 / config.renderScale)

    self.dialog = Dialog(
        self.positionX,
        self.positionY,
        self.dialogWidth,
        self.dialogHeight,
        self.dialogDepth
    )

    self.dialog:add()

    self.text = TextImage(
        self.positionX + self.margin,
        self.positionY + self.margin,
        self.dialogWidth - (self.margin * 2),
        self.dialogHeight - (self.margin * 2),
        self.dialogDepth
    )

    self.text:add()

    self.arrowDown = PromptIcon(
        self.positionX + self.dialogWidth - self.margin * 2,
        self.positionY + self.dialogHeight - self.margin,
        self.dialogDepth
    )

    self.numberOfLines = math.floor((self.dialogHeight - (self.margin * 2)) / cotton.textFontHeight)

    self.wordList = self:splitMessageIntoWordsList(message)
    self.chunkList = self:splitIntoChunksBasedOnWidth(self.dialogWidth - (self.margin * 2), cotton.textFont)
    self.completeMessageLength = #message
    self.chunkOffset = 1
    self.currentChunk = 1
    self.currentChunkLength = {}
    self.isFullyRendered = false

    self.isActive = true

    local topLeftCorner = getTopLeftCorner()
    self.textPosition = {
        x = topLeftCorner.x + self.positionX + self.margin,
        y = topLeftCorner.y + self.positionY + self.margin
    }
end

function MessageHandler:update()
    if not self.isActive then
        return
    end

    self:drawMessage()
    self.arrowDown:draw()
end

function MessageHandler:drawMessage()
    if self.isFullyRendered then
        return
    end

    if self.isPageFullyRendered then
        return
    end

    if self:isCompletedChunk() then
        if self:isLastChunk() then
            self.isFullyRendered = true
            -- End of all chunks!
            self.arrowDown:add()
            return
        end

        if self.currentChunk % self.numberOfLines == 0 then
            self.isPageFullyRendered = true
            -- Next chunk page
            self.arrowDown:add()
            return
        end

        -- Next chunk
        self.currentChunk = self.currentChunk + 1
    end

    self:drawTextInDialog()

    self.currentChunkLength[self.currentChunk] = (self.currentChunkLength[self.currentChunk] or 0) + 1
end

function MessageHandler:drawTextInDialog()
    local lineLoopIndex = 0

    while (lineLoopIndex < self.numberOfLines) do
        local chunk = self.chunkList[self.chunkOffset + lineLoopIndex]
        if chunk == nil then
            break
        end

        local truncatedMessage = string.sub(chunk, 0, self.currentChunkLength[self.chunkOffset + lineLoopIndex] or 0)
        self.text:drawText(
            truncatedMessage,
            0,
            0 + (cotton.textFontHeight * lineLoopIndex)
        )
        lineLoopIndex = lineLoopIndex + 1
    end
end

function MessageHandler:detectInput()
    if input.justPressed(buttonA) or input.justPressed(buttonB) or input.justPressed(buttonUp) or
        input.justPressed(buttonDown) or input.justPressed(buttonLeft) or input.justPressed(buttonRight) then
        if self:isLastChunk() and self:isCompletedChunk() then
            -- End of all chunks!
            self:tryClose()
            return
        end

        if self.currentChunk % self.numberOfLines == 0 then
            -- Next chunk page
            self:nextChunkPage()

            return
        end

        self:skipTransition()
        return
    end
end

function MessageHandler:getMaxWidthForOptions(options, fontSize)
    local maxWidth = 0

    for k, option in pairs(options) do
        local textSize = option.name:len() * fontSize
        if maxWidth < textSize then
            maxWidth = textSize
        end
    end

    return maxWidth
end

function MessageHandler:tryClose()
    if #self.options > 0 then
        local fontSize = 16 / config.renderScale
        local maxNumberOfItems = #self.options
        if maxNumberOfItems > 5 then
            maxNumberOfItems = 5
        end
        local minWidthForOption = self:getMaxWidthForOptions(self.options, fontSize)
        local menuDialogWidth = minWidthForOption + self.margin * 2

        cotton.menuHandler = MenuHandler({
            x = self.positionX + self.dialogWidth - (menuDialogWidth + self.margin),
            y = (self.positionY + self.dialogHeight) - (self.margin * 2),
            w = menuDialogWidth,
            h = (maxNumberOfItems * fontSize) + (self.margin * 2),
            options = self.options,
            zIndex = 1
        }, function()
            cotton.keyListener:unsetKeyListener()
            self:disableDialog()
        end)
        cotton.keyListener:setCurrentKeyListener(function() cotton.menuHandler:detectInput() end)
        return
    end

    self:disableDialog()
    if self.afterClose ~= nil then
        self.afterClose()
    end
end

function MessageHandler:nextChunkPage()
    self.isPageFullyRendered = false
    self.text:clean()
    self.arrowDown:remove()
    self.currentChunk = self.currentChunk + 1
    self.chunkOffset = self.chunkOffset + self.numberOfLines
end

function MessageHandler:skipTransition()
    local lineLoopIndex = 0

    while (lineLoopIndex < self.numberOfLines) do
        if self.chunkList[self.chunkOffset + lineLoopIndex] == nil then
            break
        end
        self.currentChunkLength[self.chunkOffset + lineLoopIndex] = #self.chunkList[self.chunkOffset + lineLoopIndex]
        lineLoopIndex = lineLoopIndex + 1
    end

    self:drawTextInDialog()
end

function MessageHandler:disableDialog()
    self.isActive = false
    self.arrowDown:remove()
    self.dialog:remove()
    self.text:remove()
    game.unfreeze()
end

function MessageHandler:splitIntoChunksBasedOnWidth(maxTextWidth, textFont)
    local chunks = {}
    local currentChunk = 1

    for key, word in pairs(self.wordList) do
        if chunks[currentChunk] == nil then
            chunks[currentChunk] = word
        elseif textFont:getTextWidth(chunks[currentChunk] .. " " .. word) <= maxTextWidth then
            chunks[currentChunk] = chunks[currentChunk] .. " " .. word
        else
            currentChunk = currentChunk + 1
            chunks[currentChunk] = word
        end
    end
    return chunks
end

function MessageHandler:splitMessageIntoWordsList(inputstring)
    local words = {}
    for str in string.gmatch(inputstring, "([^%s]+)") do
        table.insert(words, str)
    end
    return words
end

function MessageHandler:isLastChunk()
    return #self.chunkList == self.currentChunk
end

function MessageHandler:isCompletedChunk()
    return (self.currentChunkLength[self.currentChunk] or 0) > #self.chunkList[self.currentChunk]
end
