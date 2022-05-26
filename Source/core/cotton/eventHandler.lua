EventHandler = {}

function EventHandler:new()
    local obj = {
        events = {},
        isRunningEvent = false
    }

    function obj:Update()
        if not self.isRunningEvent then
            self:listenForNewEvents()
            return
        end
    end

    function obj:listenForNewEvents()
        if #self.events > 0 then
            self:markEventAsRunning()
            self.events[1].event()
        end
    end

    function obj:registerCallback(event)
        table.insert(self.events, event)
    end

    function obj:markEventAsRunning()
        self.isRunningEvent = true
    end

    function obj:markEventAsDone()
        if self.events[1].callback ~= nil then
            self.events[1].callback()
        end
        table.remove(self.events, 1)
        self.isRunningEvent = false
    end

    return obj
end
