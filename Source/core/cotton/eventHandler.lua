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
    table.remove(self.events, 1)
    self.isRunningEvent = false
end
