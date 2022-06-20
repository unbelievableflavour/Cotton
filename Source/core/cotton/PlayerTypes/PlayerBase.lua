local gfx <const> = playdate.graphics

class("PlayerBase", {
    isFrozen = false,
    sprite = nil,
    currentCollisions = {},
    isAnimated = false
}).extends()

function PlayerBase:Init()
end

function PlayerBase:update()
end

function PlayerBase:doBasicInputChecks()
    if input.justPressed(buttonA) then
        cotton.player:confirmPressed()
    end

    if input.justReleased(buttonA) then
        cotton.player:confirmReleased()
    end

    if input.justPressed(buttonB) then
        cotton.player:cancelPressed()
    end

    if input.justReleased(buttonB) then
        cotton.player:cancelReleased()
    end

    if input.onCrankDock() then
        cotton.player:dock()
    end

    if input.onCrankUndock() then
        cotton.player:undock()
    end

    if input.isCranking() then
        cotton.player:crank()
    end
end

function PlayerBase:isAtNorthRoomEdge()
    return self.sprite.y < 0
end

function PlayerBase:isAtEastRoomEdge()
    return self.sprite.x + self.sprite.width > cotton.room.w
end

function PlayerBase:isAtSouthRoomEdge()
    return self.sprite.y + self.sprite.height > cotton.room.h
end

function PlayerBase:isAtWestRoomEdge()
    return self.sprite.x < 0
end

function PlayerBase:freeze()
    self.isFrozen = true
end

function PlayerBase:unfreeze()
    self.isFrozen = false
end

function PlayerBase:fixCamera()
    local spriteX, spriteY = self.sprite:getPosition()
    if config.cameraFollowLockX then
        gfx.setDrawOffset(
            0 + self.cameraFollowOffsetX,
            screenCenterY - spriteY + config.cameraFollowOffsetY
        )
        return
    end

    if config.cameraFollowLockY then
        gfx.setDrawOffset(
            screenCenterX - spriteX + config.cameraFollowOffsetX,
            0 + config.cameraFollowOffsetY
        )
        return
    end

    gfx.setDrawOffset(
        screenCenterX - spriteX + config.cameraFollowOffsetX,
        screenCenterY - spriteY + config.cameraFollowOffsetY
    )
end

function PlayerBase:moveTo(x, y)
    self.sprite:moveTo(x, y)
end

function PlayerBase:readd(x, y)
    self.sprite:add()
    self:moveTo(x, y)
end

function PlayerBase:checkIfStillColliding(sprite)
    local collisions = sprite:overlappingSprites()
    local removedKeys = {}

    for key, value in pairs(game.player.currentCollisions) do
        local isStillColliding = false
        for i = 1, #collisions do
            if collisions[i] then
                if collisions[i].id == key then
                    isStillColliding = true
                end
            end
        end

        if not isStillColliding then
            table.insert(removedKeys, key)
        end
    end

    for i, v in pairs(removedKeys) do
        game.player.currentCollisions[v]:onTileExit()
        game.player.currentCollisions[v] = nil
    end
end

function PlayerBase:setImage(src, options)
    local options = options or {}
    if options.animated then
        self.animation = gfx.animation.loop.new(options.delay, gfx.imagetable.new(src), options.loop)
        self.isAnimated = true
        self.image = gfx.image.new(self.sprite.width, self.sprite.height)
        self.sprite:setImage(self.image)
        return
    end

    self.sprite:setImage(gfx.imagetable.new(src):getImage(1))
end

function PlayerBase:animate()
    playdate.graphics.pushContext(self.image)
    playdate.graphics.clear()
    self.animation:draw(0, 0)
    playdate.graphics.popContext()
end

function PlayerBase:shouldDraw()
    return self.isAnimated or self.isRemoved == false
end
