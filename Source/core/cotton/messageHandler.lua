local gfx <const> = playdate.graphics

import "./PromptIcon"

class(
    "MessageHandler",
    {
        isActive = false,
        wordList = {},
        chunkList = {},
        currentLength = 0,
        chunkOffset = 0,
        currentChunk = 0
    }
).extends()

function MessageHandler:new(message, x, y, width, height)
    game.freeze()
    self.isFirstFrame = true

    self.dialogWidth = width or 300
    self.dialogHeight = height or 98

    self.positionX = x or 50
    self.positionY = y or 50
    self.margin = 16

    self.dialog = Dialog(self.positionX, self.positionY, self.dialogWidth, self.dialogHeight)
    self.dialog:add()

    self.arrowDown =
        PromptIcon(
        self.positionX + self.dialogWidth - self.margin * 2,
        self.positionY + self.dialogHeight - self.margin
    )

    self.textFont = gfx.font.new("fonts/" .. config.font)
    self.textFontHeight = self.textFont:getHeight()
    self.numberOfLines = math.floor((self.dialogHeight - (self.margin * 2)) / self.textFontHeight)

    self.wordList = self:splitMessageIntoWordsList(message)
    self.chunkList = self:splitIntoChunksBasedOnWidth(self.dialogWidth - (self.margin * 2), self.textFont)
    self.completeMessageLength = #message
    self.chunkOffset = 1
    self.currentChunk = 1
    self.currentChunkLength = {}
    self.isFullyRendered = false

    self.isActive = true
end

function MessageHandler:Update()
    if not self.isActive then
        return
    end

    if not self.isFirstFrame then
        self:detectInput()
    end

    self.isFirstFrame = false
    self:drawMessage()
    self.arrowDown:draw()
end

function MessageHandler:drawMessage()
    local lineLoopIndex = 0

    local textPositionX = self.positionX + self.margin
    local textPositionY = self.positionY + self.margin

    while (lineLoopIndex < self.numberOfLines) do
        local chunk = self.chunkList[self.chunkOffset + lineLoopIndex]
        if chunk == nil then
            break
        end

        local truncatedMessage = string.sub(chunk, 0, self.currentChunkLength[self.chunkOffset + lineLoopIndex] or 0)
        self.textFont:drawText(truncatedMessage, textPositionX, textPositionY + (self.textFontHeight * lineLoopIndex))
        lineLoopIndex = lineLoopIndex + 1
    end

    if self.currentChunkLength[self.currentChunk] == #self.chunkList[self.currentChunk] then
        if #self.chunkList == self.currentChunk then
            if self.isFullyRendered then
                return
            end
            self.isFullyRendered = true
            -- End of all chunks!
            self.arrowDown:add()
            return
        end

        if self.currentChunk % self.numberOfLines == 0 then
            -- Next chunk page
            self.arrowDown:add()
            return
        end

        -- Next chunk
        self.currentChunk = self.currentChunk + 1
        return
    end

    self.currentChunkLength[self.currentChunk] = (self.currentChunkLength[self.currentChunk] or 0) + 1
end

function MessageHandler:detectInput()
    if
        playdate.buttonJustPressed(playdate.kButtonA) or playdate.buttonJustPressed(playdate.kButtonB) or
            playdate.buttonJustPressed(playdate.kButtonUp) or
            playdate.buttonJustPressed(playdate.kButtonDown) or
            playdate.buttonJustPressed(playdate.kButtonLeft) or
            playdate.buttonJustPressed(playdate.kButtonRight)
     then
        if #self.chunkList == self.currentChunk then
            -- End of all chunks!
            self:disableDialog()
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

function MessageHandler:nextChunkPage()
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
end

function MessageHandler:disableDialog()
    self.arrowDown:remove()
    self.isActive = false
    self.dialog:remove()
    cotton.eventHandler:markEventAsDone()
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
