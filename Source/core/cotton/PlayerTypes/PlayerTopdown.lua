local gfx <const> = playdate.graphics

class(
	"PlayerTopdown",
	{
		player_speed = 4,
		player_acc = 1,
		player_ground_friction = 0.8
	}
).extends()

function PlayerTopdown:Init(ldtk_entity)
	self.sprite = gfx.sprite.new(asset("player"))
	local sprite = self.sprite

	sprite:setZIndex(ldtk_entity.zIndex)
	sprite:moveTo(ldtk_entity.position.x, ldtk_entity.position.y)
	sprite:setCenter(ldtk_entity.center.x, ldtk_entity.center.y)
	sprite:setCollideRect(0, 0, sprite:getSize())
	sprite:add()

	self.isGrounded = false
	self.bangCeiling = false

	self.velocity = playdate.geometry.vector2D.new(0, 0)
end

function PlayerTopdown:Update()
	local dt = 1 / playdate.display.getRefreshRate()

	if input.x() == 0 then
		self.velocity.x = math.approach(self.velocity.x, 0, self.player_ground_friction)
		self.velocity.y = math.approach(self.velocity.y, 0, self.player_ground_friction)
	end

	if self.bangCeiling then
		self.velocity.y = 0
	end

	if self.bangWall then
		self.velocity.x = 0
	end

	-- move left/right/up/down
	if input.is(buttonLeft) then
		self.velocity.x = math.approach(self.velocity.x, -self.player_speed, self.player_acc)
	end
	if input.is(buttonRight) then
		self.velocity.x = math.approach(self.velocity.x, self.player_speed, self.player_acc)
	end
	if input.is(buttonUp) then
		self.velocity.y = math.approach(self.velocity.y, -self.player_speed, self.player_acc)
	end
	if input.is(buttonDown) then
		self.velocity.y = math.approach(self.velocity.y, self.player_speed, self.player_acc)
	end

	local goalX = self.sprite.x + self.velocity.x
	local goalY = self.sprite.y + self.velocity.y

	local _, my = self.sprite:moveWithCollisions(self.sprite.x, goalY)
	local mx, _ = self.sprite:moveWithCollisions(goalX, self.sprite.y)

	self.bangCeiling = my ~= goalY and self.velocity.y < 0
	self.bangWall = mx ~= goalX and self.velocity.x < 0

	-- check exit
	local left = self.sprite.x
	local right = self.sprite.x + self.sprite.width
	if left < 0 then
		goto_level(LDtk.get_neighbours(game.level_name, "west")[1], "West")
	end
	if right > screenWidth then
		goto_level(LDtk.get_neighbours(game.level_name, "east")[1], "East")
	end
end
