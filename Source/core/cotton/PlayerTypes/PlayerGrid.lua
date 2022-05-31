local gfx <const> = playdate.graphics

class("PlayerGrid", {
    tileSize = 16,
    transitionMovement = true,
    transitionSpeed = 2,
    allowDiagonalMovement = false,
    faceDirection = nil
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

    self:checkIfStillColliding(self.tempSprite)
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

function PlayerGrid:doCollisionCheck()
    local canMoveToLocation = true
    local collisions = self.tempSprite:overlappingSprites()
    if #collisions > 0 then
        if collisions[1].collisionType == collisionTypes.overlap then
            self.currentCollisions[collisions[1].id] = collisions[1]
            collisions[1]:onTileEnter()
            return canMoveToLocation
        end
        if collisions[1].type == "entity" and config.autoAct then
            collisions[1].interact()
        else
            cotton.player:bump()
        end
        return false
    end

    return canMoveToLocation
end

function PlayerGrid:interact()
    local collisions = self.tempSprite:overlappingSprites()
    if #collisions > 0 then
        if collisions[1].type == "entity" then
            collisions[1].interact()
        end
    end
end

function PlayerGrid:drawCursor()
    if not self.shouldMove then
        return
    end

    self.tempSprite:moveTo(self.destinationCursor.x * self.tileSize, self.destinationCursor.y * self.tileSize)

    if self:isAtEastRoomEdge() then
        goto_level(LDtk.get_neighbours(game.level_name, "east")[1], "East")
        return
    end

    if self:isAtSouthRoomEdge() then
        goto_level(LDtk.get_neighbours(game.level_name, "south")[1], "South")
        return
    end

    if self:isAtNorthRoomEdge() then
        goto_level(LDtk.get_neighbours(game.level_name, "north")[1], "North")
        return
    end

    if self:isAtWestRoomEdge() then
        goto_level(LDtk.get_neighbours(game.level_name, "west")[1], "West")
        return
    end

    local canMoveToLocation = self:doCollisionCheck()
    if not canMoveToLocation then
        self.destinationCursor.x = self.previousTile.x
        self.destinationCursor.y = self.previousTile.y
        self.shouldMove = false
        return
    end

    if self.transitionMovement == true then
        self:moveTowards()
    else
        self.sprite:moveTo(self.destinationCursor.x * self.tileSize, self.destinationCursor.y * self.tileSize)
        self:hasMoved()
    end
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

function PlayerGrid:act()
    if not self.faceDirection then
        log("just entered the game!")
        return
    end

    local tile = self:getPositionForDirection(self.faceDirection)
    self.tempSprite:moveTo(tile.x * self.tileSize, tile.y * self.tileSize)
    self:interact()
end

function PlayerGrid:getPositionForDirection(direction)
    local destinationDictionary = {
        west = {
            x = self.destinationCursor.x - 1,
            y = self.destinationCursor.y
        },
        east = {
            x = self.destinationCursor.x + 1,
            y = self.destinationCursor.y
        },
        north = {
            x = self.destinationCursor.x,
            y = self.destinationCursor.y - 1
        },
        south = {
            x = self.destinationCursor.x,
            y = self.destinationCursor.y + 1
        }
    }
    return destinationDictionary[direction]
end

function PlayerGrid:detectInput()
    self:resetPreviousTileToPlayer()

    self:doBasicInputChecks()

    if input.onRepeat(buttonLeft) then
        cotton.player:update()

        self.faceDirection = "west"

        local destination = self:getPositionForDirection(self.faceDirection)
        self.destinationCursor.x = destination.x
        self.destinationCursor.y = destination.y
        self.shouldMove = true

        if not self.allowDiagonalMovement then
            return
        end
    end

    if input.onRepeat(buttonRight) then
        cotton.player:update()

        self.faceDirection = "east"

        local destination = self:getPositionForDirection(self.faceDirection)
        self.destinationCursor.x = destination.x
        self.destinationCursor.y = destination.y
        self.shouldMove = true

        if not self.allowDiagonalMovement then
            return
        end
    end

    if input.onRepeat(buttonUp) then
        cotton.player:update()

        self.faceDirection = "north"

        local destination = self:getPositionForDirection(self.faceDirection)
        self.destinationCursor.x = destination.x
        self.destinationCursor.y = destination.y
        self.shouldMove = true

        if not self.allowDiagonalMovement then
            return
        end
    end

    if input.onRepeat(buttonDown) then
        cotton.player:update()

        self.faceDirection = "south"

        local destination = self:getPositionForDirection(self.faceDirection)
        self.destinationCursor.x = destination.x
        self.destinationCursor.y = destination.y
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

function PlayerGrid:moveTo(x, y)
    self.sprite:moveTo(x, y)
    self.destinationCursor.x = x / self.tileSize
    self.destinationCursor.y = y / self.tileSize
end

function PlayerGrid:readd(x, y)
    self.sprite:add()
    self.tempSprite:add()
    self:moveTo(x, y)
end
