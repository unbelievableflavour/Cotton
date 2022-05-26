PlayerGrid = {}

local gfx = playdate.graphics
local tilesSize = 16
local tileGridWidth = 50
local tileGridHeight = 30

local transitionMovement = true
local transitionSpeed = 2
local allowDiagonalMovement = false

local currentCollisions = {}

function PlayerGrid:Init(ldtk_entity)
	self.previousTile = playdate.geometry.point.new(ldtk_entity.position.x / tilesSize, ldtk_entity.position.y / tilesSize)
	self.destinationCursor =
		playdate.geometry.point.new(ldtk_entity.position.x / tilesSize, ldtk_entity.position.y / tilesSize)

	self.sprite = playdate.graphics.sprite.new(asset("playerGrid"))
	local sprite = self.sprite

	sprite:setZIndex(ldtk_entity.zIndex)
	sprite:moveTo(ldtk_entity.position.x, ldtk_entity.position.y)
	sprite:setCenter(ldtk_entity.center.x, ldtk_entity.center.y)
	-- sprite:setCollideRect( 0,0, sprite:getSize() )
	sprite:add()

	self.tempSprite = playdate.graphics.sprite.new(asset("playerGrid"))
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

	for key, value in pairs(currentCollisions) do
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
		currentCollisions[v]:onTileExit()
		currentCollisions[v] = nil
	end
end

function PlayerGrid:moveTowards()
	local spriteX, spriteY = self.sprite:getPosition()
	if spriteX == self.destinationCursor.x * tilesSize and spriteY == self.destinationCursor.y * tilesSize then
		self:hasMoved()
		return
	end

	local newX = spriteX
	local newY = spriteY

	if spriteX < self.destinationCursor.x * tilesSize then
		newX = spriteX + transitionSpeed
	end
	if spriteX > self.destinationCursor.x * tilesSize then
		newX = spriteX - transitionSpeed
	end

	if spriteY < self.destinationCursor.y * tilesSize then
		newY = spriteY + transitionSpeed
	end
	if spriteY > self.destinationCursor.y * tilesSize then
		newY = spriteY - transitionSpeed
	end

	self.sprite:moveTo(newX, newY)
end

function PlayerGrid:doCollisionCheck(spriteX, spriteY)
	local canMoveToLocation = true
	local collisions = self.tempSprite:overlappingSprites()
	if #collisions > 0 then
		if collisions[1].collisionType == "overlap" then
			currentCollisions[collisions[1].id] = collisions[1]
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

	self.tempSprite:moveTo(self.destinationCursor.x * tilesSize, self.destinationCursor.y * tilesSize)
	local spriteX, spriteY = self.sprite:getPosition()
	local canMoveToLocation = self:doCollisionCheck(spriteX, spriteY)

	if not canMoveToLocation then
		return
	end

	if transitionMovement == true then
		self:moveTowards()
	else
		self.sprite:moveTo(self.destinationCursor.x * tilesSize, self.destinationCursor.y * tilesSize)
		self:hasMoved()
	end
end

function PlayerGrid:fixCamera()
	local spriteX, spriteY = self.sprite:getPosition()
	playdate.graphics.setDrawOffset(0 + 200 - spriteX, 120 - spriteY)
end

function PlayerGrid:getEntityOnPosition()
	local spriteTileX = self.destinationCursor.x
	local spriteTileY = self.destinationCursor.y
	for index, entity in ipairs(LDtk.get_entities("Level_0")) do
		if
			entity.fields.HasClass == true and entity.position.x / tilesSize == spriteTileX and
				entity.position.y / tilesSize == spriteTileY
		 then
			return entity
		end
	end
	return nil
end

function PlayerGrid:detectInput()
	-- move left/right/up/down
	self:resetPreviousTileToPlayer()

	if playdate.buttonJustPressed(playdate.kButtonA) then
		cotton.player:confirmPressed()
	end

	if playdate.buttonJustReleased(playdate.kButtonA) then
		cotton.player:confirmReleased()
	end

	if playdate.buttonJustPressed(playdate.kButtonB) then
		cotton.player:cancelPressed()
	end

	if playdate.buttonJustReleased(playdate.kButtonB) then
		cotton.player:cancelReleased()
	end

	if input.is(buttonLeft) then
		cotton.player:update()

		if self:isAtWestScreenEdge() then
			goto_level(LDtk.get_neighbours(game.level_name, "west")[1], "West")
			return
		end

		self.destinationCursor.x = self.destinationCursor.x - 1
		self.destinationCursor.y = self.destinationCursor.y
		self.shouldMove = true

		if not allowDiagonalMovement then
			return
		end
	end
	if input.is(buttonRight) then
		cotton.player:update()

		if self:isAtEastScreenEdge() then
			goto_level(LDtk.get_neighbours(game.level_name, "east")[1], "East")
			return
		end
		self.destinationCursor.x = self.destinationCursor.x + 1
		self.destinationCursor.y = self.destinationCursor.y
		self.shouldMove = true

		if not allowDiagonalMovement then
			return
		end
	end

	if input.is(buttonUp) then
		cotton.player:update()

		if self:isAtNorthScreenEdge() then
			goto_level(LDtk.get_neighbours(game.level_name, "north")[1], "North")
			return
		end

		self.destinationCursor.x = self.destinationCursor.x
		self.destinationCursor.y = self.destinationCursor.y - 1
		self.shouldMove = true

		if not allowDiagonalMovement then
			return
		end
	end
	if input.is(buttonDown) then
		cotton.player:update()

		if self:isAtSouthScreenEdge() then
			goto_level(LDtk.get_neighbours(game.level_name, "south")[1], "South")
			return
		end

		self.destinationCursor.x = self.destinationCursor.x
		self.destinationCursor.y = self.destinationCursor.y + 1
		self.shouldMove = true

		if not allowDiagonalMovement then
			return
		end
	end
end

function PlayerGrid:resetPreviousTileToPlayer()
	self.previousTile.x = self.destinationCursor.x
	self.previousTile.y = self.destinationCursor.y
end

function PlayerGrid:Update()
	local dt = 1 / playdate.display.getRefreshRate()

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

function PlayerGrid:isAtNorthScreenEdge()
	return self.sprite.y == 0
end

function PlayerGrid:isAtEastScreenEdge()
	return self.sprite.x + self.sprite.width == screenWidth
end

function PlayerGrid:isAtSouthScreenEdge()
	return self.sprite.y + self.sprite.height == screenHeight
end

function PlayerGrid:isAtWestScreenEdge()
	return self.sprite.x == 0
end

function PlayerGrid:freeze()
	self.isFrozen = true
end

function PlayerGrid:unfreeze()
	self.isFrozen = false
end
