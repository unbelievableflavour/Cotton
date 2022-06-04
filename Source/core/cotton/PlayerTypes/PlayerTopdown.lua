local gfx <const> = playdate.graphics

class("PlayerTopdown", {
    playerSpeed = 4,
    playerAcceleration = 1,
    playerGroundFriction = 0.8,
    currentCollisions = {}
}).extends(PlayerBase)

function PlayerTopdown:Init(ldtk_entity)
    self.sprite = gfx.sprite.new(asset("playerGrid"))
    local sprite = self.sprite

    sprite:setZIndex(ldtk_entity.zIndex)
    sprite:moveTo(ldtk_entity.position.x, ldtk_entity.position.y)
    sprite:setCenter(ldtk_entity.center.x, ldtk_entity.center.y)
    sprite:setCollideRect(0, 0, sprite:getSize())
    sprite:add()

    self.isGrounded = false
    self.bangCeiling = false

    self.velocity = playdate.geometry.vector2D.new(0, 0)

    function sprite:collisionResponse(other)
        if other.collisionType then
            if other.collisionType == collisionTypes.overlap then
                game.player.currentCollisions[other.id] = other
                other:onTileEnter()
            end

            if config.autoAct then
                other:interact()
            end

            return collisionTypes[other.collisionType]
        end

        return collisionTypes.slide
    end
end

function PlayerTopdown:update()
    if self.isFrozen then
        return
    end

    if config.cameraFollow then
        self:fixCamera()
    end

    self:doBasicInputChecks()
    self:checkIfStillColliding(self.sprite)

    if input.x() == 0 or input.y() == 0 then
        self.velocity.x = math.approach(self.velocity.x, 0, self.playerGroundFriction)
        self.velocity.y = math.approach(self.velocity.y, 0, self.playerGroundFriction)
    end

    if self.bangCeiling then
        cotton.player:bump()
        self.velocity.y = 0
    end

    if self.bangWall then
        cotton.player:bump()
        self.velocity.x = 0
    end

    -- move left/right/up/down
    if input.is(buttonLeft) then
        self.velocity.x = math.approach(self.velocity.x, -self.playerSpeed, self.playerAcceleration)
    end
    if input.is(buttonRight) then
        self.velocity.x = math.approach(self.velocity.x, self.playerSpeed, self.playerAcceleration)
    end
    if input.is(buttonUp) then
        self.velocity.y = math.approach(self.velocity.y, -self.playerSpeed, self.playerAcceleration)
    end
    if input.is(buttonDown) then
        self.velocity.y = math.approach(self.velocity.y, self.playerSpeed, self.playerAcceleration)
    end

    local goalX = self.sprite.x + self.velocity.x
    local goalY = self.sprite.y + self.velocity.y

    local _, my = self.sprite:moveWithCollisions(self.sprite.x, goalY)
    local mx, _ = self.sprite:moveWithCollisions(goalX, self.sprite.y)

    self.bangCeiling = my ~= goalY and self.velocity.y < 0
    self.bangWall = mx ~= goalX and self.velocity.x < 0

    if self:isAtEastRoomEdge() then
        goto_level(LDtk.get_neighbours(game.level_name, "east")[1], "East")
        return
    end
    if self:isAtWestRoomEdge() then
        goto_level(LDtk.get_neighbours(game.level_name, "west")[1], "West")
        return
    end
    if self:isAtNorthRoomEdge() then
        goto_level(LDtk.get_neighbours(game.level_name, "north")[1], "North")
        return
    end
    if self:isAtSouthRoomEdge() then
        goto_level(LDtk.get_neighbours(game.level_name, "south")[1], "South")
        return
    end
end
