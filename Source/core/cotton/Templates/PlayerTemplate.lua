class("PlayerTemplate", {}).extends()

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

function PlayerTemplate:hide()
    game.player.sprite:remove()
end

function PlayerTemplate:show()
    game.player.sprite:add()
end