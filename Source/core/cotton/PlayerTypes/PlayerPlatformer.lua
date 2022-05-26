PlayerPlatformer = {}

function PlayerPlatformer:Init(ldtk_entity)
	self.sprite = playdate.graphics.sprite.new(asset("player"))
	local sprite = self.sprite

	sprite:setZIndex(ldtk_entity.zIndex)
	sprite:moveTo(ldtk_entity.position.x, ldtk_entity.position.y)
	sprite:setCenter(ldtk_entity.center.x, ldtk_entity.center.y)
	sprite:setCollideRect(0, 0, sprite:getSize())
	sprite:add()

	self.isGrounded = false
	self.justLanded = false
	self.bangCeiling = false
	self.groundedLast = 0
	self.lastJumpPress = live.jump_buffer
	self.jumpPressDuration = 0

	self.velocity = playdate.geometry.vector2D.new(0, 0)
end

function PlayerPlatformer:Update()
	local dt = 1 / playdate.display.getRefreshRate()

	-- Friction
	if self.isGrounded then
		if input.x() == 0 then
			self.velocity.x = math.approach(self.velocity.x, 0, live.player_ground_friction)
		end
		self.velocity.y = 0
	else
		if input.x() == 0 then
			self.velocity.x = math.approach(self.velocity.x, 0, live.player_air_friction)
		end

		if self.bangCeiling then
			self.velocity.y = 0
		end
	end

	-- move left/right
	if input.is(buttonLeft) then
		self.velocity.x = math.approach(self.velocity.x, -live.player_speed, live.player_acc)
	-- self.sprite:setImageFlip(playdate.graphics.kImageFlippedX)
	end
	if input.is(buttonRight) then
		self.velocity.x = math.approach(self.velocity.x, live.player_speed, live.player_acc)
	-- self.sprite:setImageFlip(playdate.graphics.kImageUnflipped)
	end

	-- Jump
	self.groundedLast = self.groundedLast + dt
	if self.isGrounded then
		self.groundedLast = 0
	end

	self.lastJumpPress = self.lastJumpPress + dt
	if input.on(buttonA) then
		self.lastJumpPress = 0
	end

	if self.jumpPressDuration > 0 then
		if input.is(buttonA) then
			self.velocity.y = live.jump_velocity
			self.jumpPressDuration = self.jumpPressDuration - dt
		else
			self.jumpPressDuration = 0
		end
	end

	if self.lastJumpPress < live.jump_buffer and self.groundedLast < live.jump_grace then
		self.velocity.y = live.jump_velocity
		self.isGrounded = false

		self.lastJumpPress = live.jump_buffer
		self.groundedLast = live.jump_grace
		self.jumpPressDuration = live.jump_long_press
	end

	-- Gravity
	if self.velocity.y >= 0 then
		self.velocity.y = math.min(self.velocity.y + live.gravity_down * dt, live.player_max_gravity)
	else
		self.velocity.y = self.velocity.y + live.gravity_up * dt
	end

	local goalX = self.sprite.x + self.velocity.x
	local goalY = self.sprite.y + self.velocity.y

	local _, my = self.sprite:moveWithCollisions(self.sprite.x, goalY)
	local mx, _ = self.sprite:moveWithCollisions(goalX, self.sprite.y)

	local isGrounded = my ~= goalY and self.velocity.y > 0
	self.justLanded = isGrounded and not self.isGrounded
	self.isGrounded = isGrounded
	self.bangCeiling = my ~= goalY and self.velocity.y < 0

	-- check exit
	local left = self.sprite.x
	local right = self.sprite.x + self.sprite.width
	if left < 0 then
		goto_level(LDtk.get_neighbours(game.level_name, "west")[1], "West")
	end
	if right > 400 then
		goto_level(LDtk.get_neighbours(game.level_name, "east")[1], "East")
	end
end