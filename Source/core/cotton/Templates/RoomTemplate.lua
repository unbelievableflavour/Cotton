class("RoomTemplate", {
    x = nil,
    y = nil,
    w = nil,
    h = nil
}).extends()

function RoomTemplate:load()
    -- log("room: load")
end

function RoomTemplate:enter()
    -- log("room: enter")
end

function RoomTemplate:exit()
    -- log("room: exit")
end

function RoomTemplate:setDimensions(positionAndSize)
    self.x = positionAndSize.x or nil
    self.y = positionAndSize.y or nil
    self.w = positionAndSize.width or nil
    self.h = positionAndSize.height or nil
end
