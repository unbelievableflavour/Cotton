import "./PromptIcon"

local messaging = {
    wordList = {},
    chunkList = {},
    currentLength = 0,
    chunkOffset = 0,
    currentChunk = 0
}

MessageHandler = {}

function MessageHandler:new()
    local obj = {
        isActive = false
    }

    function obj:init(message, x, y, width, height)
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

        messaging.wordList = self:splitMessageIntoWordsList(message)
        messaging.chunkList = self:splitIntoChunksBasedOnWidth(self.dialogWidth - (self.margin * 2), self.textFont)
        messaging.completeMessageLength = #message
        messaging.chunkOffset = 1
        messaging.currentChunk = 1
        messaging.currentChunkLength = {}
        messaging.isFullyRendered = false

        self.isActive = true
    end

    function obj:Update()
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

    function obj:drawMessage()
        local lineLoopIndex = 0

        local textPositionX = self.positionX + self.margin
        local textPositionY = self.positionY + self.margin

        while (lineLoopIndex < self.numberOfLines) do
            local chunk = messaging.chunkList[messaging.chunkOffset + lineLoopIndex]
            if chunk == nil then
                break
            end

            local truncatedMessage =
                string.sub(chunk, 0, messaging.currentChunkLength[messaging.chunkOffset + lineLoopIndex] or 0)
            self.textFont:drawText(
                truncatedMessage,
                textPositionX,
                textPositionY + (self.textFontHeight * lineLoopIndex)
            )
            lineLoopIndex = lineLoopIndex + 1
        end

        if messaging.currentChunkLength[messaging.currentChunk] == #messaging.chunkList[messaging.currentChunk] then
            if #messaging.chunkList == messaging.currentChunk then
                if messaging.isFullyRendered then
                    return
                end
                messaging.isFullyRendered = true
                -- End of all chunks!
                self.arrowDown:add()
                return
            end

            if messaging.currentChunk % self.numberOfLines == 0 then
                -- Next chunk page
                self.arrowDown:add()
                return
            end

            -- Next chunk
            messaging.currentChunk = messaging.currentChunk + 1
            return
        end

        messaging.currentChunkLength[messaging.currentChunk] =
            (messaging.currentChunkLength[messaging.currentChunk] or 0) + 1
    end

    function obj:detectInput()
        if
            playdate.buttonJustPressed(playdate.kButtonA) or playdate.buttonJustPressed(playdate.kButtonB) or
                playdate.buttonJustPressed(playdate.kButtonUp) or
                playdate.buttonJustPressed(playdate.kButtonDown) or
                playdate.buttonJustPressed(playdate.kButtonLeft) or
                playdate.buttonJustPressed(playdate.kButtonRight)
         then
            if #messaging.chunkList == messaging.currentChunk then
                -- End of all chunks!
                obj:disableDialog()
                return
            end

            if messaging.currentChunk % self.numberOfLines == 0 then
                -- Next chunk page
                obj:nextChunkPage()

                return
            end

            obj:skipTransition()
            return
        end
    end

    function obj:nextChunkPage()
        self.arrowDown:remove()
        messaging.currentChunk = messaging.currentChunk + 1
        messaging.chunkOffset = messaging.chunkOffset + self.numberOfLines
    end

    function obj:skipTransition()
        local lineLoopIndex = 0

        while (lineLoopIndex < self.numberOfLines) do
            if messaging.chunkList[messaging.chunkOffset + lineLoopIndex] == nil then
                break
            end
            messaging.currentChunkLength[messaging.chunkOffset + lineLoopIndex] =
                #messaging.chunkList[messaging.chunkOffset + lineLoopIndex]
            lineLoopIndex = lineLoopIndex + 1
        end
    end

    function obj:disableDialog()
        self.arrowDown:remove()
        self.isActive = false
        self.dialog:remove()
        cotton.eventHandler:markEventAsDone()
        game.unfreeze()
    end

    function obj:splitIntoChunksBasedOnWidth(maxTextWidth, textFont)
        local chunks = {}
        local currentChunk = 1

        for key, word in pairs(messaging.wordList) do
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

    function obj:splitMessageIntoWordsList(inputstring)
        local words = {}
        for str in string.gmatch(inputstring, "([^%s]+)") do
            table.insert(words, str)
        end
        return words
    end

    return obj
end
