local gfx<const> = playdate.graphics

class("PlayerGrid", {
    tileSize = 16,
    transitionMovement = true,
    transitionSpeed = 2,
    allowDiagonalMovement = false,
    currentCollisions = {}
}).extends(PlayerBase)

function PlayerGrid:Init(ldtk_entity)
    self.previousTile = playdate.geometry.point.new(ldtk_entity.position.x / self.tileSize,
        ldtk_entity.position.y / self.tileSize)
    self.destinationCursor = playdate.geometry.point.new(ldtk_entity.position.x / self.tileSize,
        ldtk_entity.position.y / self.tileSize)

    self.sprite = gfx.sprite.new(asset("playerGrid"))
    local sprite = self.sprite

    sprite:setZIndex(ldtk_entity.zIndex)
    sprite:moveTo(ldtk_entity.position.x, ldtk_entity.position.y)
    sprite:setCenter(ldtk_entity.center.x, ldtk_entity.center.y)
    -- sprite:setCollideRect( 0,0, sprite:getSize() )
    sprite:add()

    self.tempSprite = gfx.sprite.new(asset("playerGrid"))
    self.tempSprite:setZIndex(-100)
    self.tempSprite:moveTo(ldtk_entity.position.x, ldtk_entity.position.y)
    self.tempSprite:setCenter(ldtk_entity.center.x, ldtk_entity.center.y)
    self.tempSprite:setCollideRect(0, 0, self.tempSprite:getSize())
    self.tempSprite:add()
end

function PlayerGrid:hasMoved()
    self.shouldMove = false

    local collisions = self.tempSprite:overlappingSprites()
    local removedKeys = {}

    for key, value in pairs(self.currentCollisions) do
        local isStillColliding = false
        for i = 1, #collisions do
            if collisions[i].entity then
                if collisions[i].entity.id == key then
                    isStillColliding = true
                end
            end
        end

        if not isStillColliding then
            table.insert(removedKeys, key)
        end
    end

    for i, v in pairs(removedKeys) do
        self.currentCollisions[v]:onTileExit()
        self.currentCollisions[v] = nil
    end
end

function PlayerGrid:moveTowards()
    local spriteX, spriteY = self.sprite:getPosition()
    if spriteX == self.destinationCursor.x * self.tileSize and spriteY == self.destinationCursor.y * self.tileSize then
        self:hasMoved()
        return
    end

    local newX = spriteX
    local newY = spriteY

    if spriteX < self.destinationCursor.x * self.tileSize then
        newX = spriteX + self.transitionSpeed
    end
    if spriteX > self.destinationCursor.x * self.tileSize then
        newX = spriteX - self.transitionSpeed
    end

    if spriteY < self.destinationCursor.y * self.tileSize then
        newY = spriteY + self.transitionSpeed
    end
    if spriteY > self.destinationCursor.y * self.tileSize then
        newY = spriteY - self.transitionSpeed
    end

    self.sprite:moveTo(newX, newY)
end

function PlayerGrid:doCollisionCheck(spriteX, spriteY)
    local canMoveToLocation = true
    local collisions = self.tempSprite:overlappingSprites()
    if #collisions > 0 then
        if collisions[1].collisionType == "overlap" then
            self.currentCollisions[collisions[1].id] = collisions[1]
            collisions[1]:onTileEnter()
            return canMoveToLocation
        end
        if collisions[1].type == "entity" then
            collisions[1].interact()
        else
            cotton.player:bump()
        end
        self.destinationCursor.x = self.previousTile.x
        self.destinationCursor.y = self.previousTile.y
        self.sprite:moveTo(spriteX, spriteY)
        self.shouldMove = false
        return false
    end

    return canMoveToLocation
end

function PlayerGrid:drawCursor()
    if not self.shouldMove then
        return
    end

    self.tempSprite:moveTo(self.destinationCursor.x * self.tileSize, self.destinationCursor.y * self.tileSize)

    if self:isAtEastScreenEdge() then
        goto_level(LDtk.get_neighbours(game.level_name, "east")[1], "East")
        return
    end

    if self:isAtSouthScreenEdge() then
        goto_level(LDtk.get_neighbours(game.level_name, "south")[1], "South")
        return
    end

    if self:isAtNorthScreenEdge() then
        goto_level(LDtk.get_neighbours(game.level_name, "north")[1], "North")
        return
    end

    if self:isAtWestScreenEdge() then
        goto_level(LDtk.get_neighbours(game.level_name, "west")[1], "West")
        return
    end

    local spriteX, spriteY = self.sprite:getPosition()
    local canMoveToLocation = self:doCollisionCheck(spriteX, spriteY)

    if not canMoveToLocation then
        return
    end

    if self.transitionMovement == true then
        self:moveTowards()
    else
        self.sprite:moveTo(self.destinationCursor.x * self.tileSize, self.destinationCursor.y * self.tileSize)
        self:hasMoved()
    end
end

function PlayerGrid:fixCamera()
    local spriteX, spriteY = self.sprite:getPosition()
    gfx.setDrawOffset(screenCenterX - spriteX, screenCenterY - spriteY)
end

function PlayerGrid:getEntityOnPosition()
    local spriteTileX = self.destinationCursor.x
    local spriteTileY = self.destinationCursor.y
    for index, entity in ipairs(LDtk.get_entities("Level_0")) do
        if entity.fields.HasClass == true and entity.position.x / self.tileSize == spriteTileX and entity.position.y /
            self.tileSize == spriteTileY then
            return entity
        end
    end
    return nil
end

function PlayerGrid:detectInput()
    self:resetPreviousTileToPlayer()

    if input.justPressed(buttonA) then
        cotton.player:confirmPressed()
    end

    if input.justPressed(buttonA) then
        cotton.player:confirmReleased()
    end

    if input.justPressed(buttonB) then
        cotton.player:cancelPressed()
    end

    if input.justPressed(buttonB) then
        cotton.player:cancelReleased()
    end

    if input.is(buttonLeft) then
        cotton.player:update()

        self.destinationCursor.x = self.destinationCursor.x - 1
        self.destinationCursor.y = self.destinationCursor.y
        self.shouldMove = true

        if not self.allowDiagonalMovement then
            return
        end
    end

    if input.is(buttonRight) then
        cotton.player:update()

        self.destinationCursor.x = self.destinationCursor.x + 1
        self.destinationCursor.y = self.destinationCursor.y
        self.shouldMove = true

        if not self.allowDiagonalMovement then
            return
        end
    end

    if input.is(buttonUp) then
        cotton.player:update()

        self.destinationCursor.x = self.destinationCursor.x
        self.destinationCursor.y = self.destinationCursor.y - 1
        self.shouldMove = true

        if not self.allowDiagonalMovement then
            return
        end
    end

    if input.is(buttonDown) then
        cotton.player:update()

        self.destinationCursor.x = self.destinationCursor.x
        self.destinationCursor.y = self.destinationCursor.y + 1
        self.shouldMove = true

        if not self.allowDiagonalMovement then
            return
        end
    end
end

function PlayerGrid:resetPreviousTileToPlayer()
    self.previousTile.x = self.destinationCursor.x
    self.previousTile.y = self.destinationCursor.y
end

function PlayerGrid:update()
    if self.isFrozen then
        return
    end

    if self.shouldMove then
        self:drawCursor()

        if config.cameraFollow then
            self:fixCamera()
        end
        if self.shouldMove then
            return
        end
    end

    if self.sprite == nil then
        return
    end

    self:detectInput()
    self:drawCursor()

    if config.cameraFollow then
        self:fixCamera()
    end
end
