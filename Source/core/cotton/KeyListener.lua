local gfx <const> = playdate.graphics

class("KeyListener", {
    keyListener = nil
}).extends()

function KeyListener:new()
end

function KeyListener:update()
    if self.keyListener == nil then
        return
    end

    if self.firstFrame then
        self.firstFrame = false
        return
    end

    self.keyListener()
end

function KeyListener:setCurrentKeyListener(listener)
    self.keyListener = listener
    self.firstFrame = true
end

function KeyListener:unsetKeyListener()
    self.keyListener = nil
end
