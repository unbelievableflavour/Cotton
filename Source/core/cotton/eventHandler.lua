class("EventHandler", {
    events = {},
    isRunningEvent = false
}).extends()

function EventHandler:update()
    if not self.isRunningEvent then
        self:listenForNewEvents()
        return
    end
end

function EventHandler:listenForNewEvents()
    if #self.events > 0 then
        self:markEventAsRunning()
        self.events[1].event()

        if self.events[1].keyListener ~= nil then
            cotton.keyListener:setCurrentKeyListener(self.events[1].keyListener)
        end
    end
end

function EventHandler:registerCallback(event)
    table.insert(self.events, event)
end

function EventHandler:markEventAsRunning()
    self.isRunningEvent = true
end

function EventHandler:markEventAsDone()
    if self.events[1].callback ~= nil then
        self.events[1].callback()
    end
    cotton.keyListener:unsetKeyListener()
    table.remove(self.events, 1)
    self.isRunningEvent = false
end
