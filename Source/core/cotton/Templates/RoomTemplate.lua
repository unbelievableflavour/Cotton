class("RoomTemplate", {
    offsetFromPreviousRoom = {
        x = 0,
        y = 0,
    },
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

function RoomTemplate:setDimensions(positionAndSize, previousDimension)
    self.x = positionAndSize.x
    self.y = positionAndSize.y
    self.w = positionAndSize.width
    self.h = positionAndSize.height

    if previousDimension ~= nil then
        self.offsetFromPreviousRoom = {
            x = self.x - previousDimension.x,
            y = self.y - previousDimension.y
        }
        log(self.offsetFromPreviousRoom)
    end
end
