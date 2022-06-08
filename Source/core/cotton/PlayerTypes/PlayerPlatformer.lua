local gfx <const> = playdate.graphics

class("PlayerPlatformer", {
    playerSpeed = 5,
    playerAcceleration = 1,
    playerGroundFriction = 0.8,
    playerAirFriction = 0.3,
    jumpGrace = 0.1,
    jumpBuffer = 0.1,
    jumpLongPress = 0.12,
    jumpVelocity = -15,
    gravityUp = 80,
    gravityDown = 130,
    playerMaxGravity = 40
}).extends(PlayerBase)

function PlayerPlatformer:Init(ldtk_entity)
    local imagetable = gfx.imagetable.new("images/player")

    self.sprite = gfx.sprite.new(imagetable:getImage(1))
    local sprite = self.sprite

    sprite:setZIndex(ldtk_entity.zIndex)
    sprite:moveTo(ldtk_entity.position.x, ldtk_entity.position.y)
    sprite:setCenter(ldtk_entity.center.x, ldtk_entity.center.y)
    sprite:setCollideRect(0, 0, sprite:getSize())
    sprite:add()

    self.isGrounded = false
    self.justLanded = false
    self.bangCeiling = false
    self.bangWall = false
    self.groundedLast = 0
    self.lastJumpPress = self.jumpBuffer
    self.jumpPressDuration = 0

    self.velocity = playdate.geometry.vector2D.new(0, 0)

    function sprite:collisionResponse(other)
        if other.collisionType then
            if other.collisionType == collisionTypes.overlap then
                if game.player.currentCollisions[other.id] == nil then
                    game.player.currentCollisions[other.id] = other
                    other:onTileEnter()
                end
            end

            if config.autoAct then
                other:interact()
            end

            return collisionTypes[other.collisionType]
        end

        return collisionTypes.slide
    end
end

function PlayerPlatformer:update()
    if self.isFrozen then
        return
    end

    if config.cameraFollow then
        self:fixCamera()
    end

    self:doBasicInputChecks()
    self:checkIfStillColliding(self.sprite)

    local dt = 1 / playdate.display.getRefreshRate()

    -- Friction
    if self.isGrounded then
        if input.x() == 0 then
            self.velocity.x = math.approach(self.velocity.x, 0, self.playerGroundFriction)
        end
        self.velocity.y = 0
    else
        if input.x() == 0 then
            self.velocity.x = math.approach(self.velocity.x, 0, self.playerAirFriction)
        end

        if self.bangCeiling then
            cotton.player:bump()
            self.velocity.y = 0
        end
    end

    if self.bangWall then
        cotton.player:bump()
    end

    -- move left/right
    if input.is(buttonLeft) then
        self.velocity.x = math.approach(self.velocity.x, -self.playerSpeed, self.playerAcceleration)
        -- self.sprite:setImageFlip(gfx.kImageFlippedX)
    end
    if input.is(buttonRight) then
        self.velocity.x = math.approach(self.velocity.x, self.playerSpeed, self.playerAcceleration)
        -- self.sprite:setImageFlip(gfx.kImageUnflipped)
    end

    -- Jump
    self.groundedLast = self.groundedLast + dt
    if self.isGrounded then
        self.groundedLast = 0
    end

    self.lastJumpPress = self.lastJumpPress + dt
    if input.justPressed(buttonA) then
        self.lastJumpPress = 0
    end

    if self.jumpPressDuration > 0 then
        if input.is(buttonA) then
            self.velocity.y = self.jumpVelocity
            self.jumpPressDuration = self.jumpPressDuration - dt
        else
            self.jumpPressDuration = 0
        end
    end

    if self.lastJumpPress < self.jumpBuffer and self.groundedLast < self.jumpGrace then
        self.velocity.y = self.jumpVelocity
        self.isGrounded = false

        self.lastJumpPress = self.jumpBuffer
        self.groundedLast = self.jumpGrace
        self.jumpPressDuration = self.jumpLongPress
    end

    -- Gravity
    if self.velocity.y >= 0 then
        self.velocity.y = math.min(self.velocity.y + self.gravityDown * dt, self.playerMaxGravity)
    else
        self.velocity.y = self.velocity.y + self.gravityUp * dt
    end

    local goalX = self.sprite.x + self.velocity.x
    local goalY = self.sprite.y + self.velocity.y

    local _, my = self.sprite:moveWithCollisions(self.sprite.x, goalY)
    local mx, _ = self.sprite:moveWithCollisions(goalX, self.sprite.y)

    local isGrounded = my ~= goalY and self.velocity.y > 0
    self.justLanded = isGrounded and not self.isGrounded
    self.isGrounded = isGrounded
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
