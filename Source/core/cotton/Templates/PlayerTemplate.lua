class("PlayerTemplate", {
    player = nil
}).extends()

function PlayerTemplate:load()
    -- log("player: load")
end

function PlayerTemplate:draw()
    -- log("player: draw")
end

function PlayerTemplate:update()
    -- log("player: update")
end

function PlayerTemplate:enter()
    -- log("player: enter")
end

function PlayerTemplate:bump()
    -- log("player: bump")
end

function PlayerTemplate:exit()
    -- log("player: exit")
end

function PlayerTemplate:confirmPressed()
    -- log("player: confirm pressed")
end

function PlayerTemplate:confirmReleased()
    -- log("player: confirm released")
end

function PlayerTemplate:cancelPressed()
    -- log("player: cancel pressed")
end

function PlayerTemplate:cancelReleased()
    -- log("player: cancel released")
end

function PlayerTemplate:crank()
    -- log("player: crank")
end

function PlayerTemplate:dock()
    -- log("player: dock")
end

function PlayerTemplate:undock()
    -- log("player: undock")
end

function PlayerTemplate:UpdatePlayerObj()
    self.player = game.player
end

function PlayerTemplate:setImage(image)
    self.player.sprite:setImage(image)
end

function PlayerTemplate:setProperty(propKey, propValue)
    self.player[propKey] = propValue
end

function PlayerTemplate:change()
    -- log("player: change")
end

function PlayerTemplate:select()
    -- log("player: select")
end

function PlayerTemplate:dismiss()
    -- log("player: dismiss")
end
