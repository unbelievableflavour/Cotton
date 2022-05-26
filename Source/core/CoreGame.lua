game = {
	activeEntities = {}
}

save = {}

cotton = {
	activeEntities = {},
	game = nil,
	player = nil
}

adapterDictionary = {
	grid = PlayerGrid,
	platformer = PlayerPlatformer,
	topdown = PlayerTopdown
}

local _background_sprite = playdate.graphics.sprite.new()
local backgroundImg = nil

function game.init(level_name)
	cotton.menuHandler = MenuHandler()
	cotton.messageHandler = MessageHandler()
	cotton.eventHandler = EventHandler()
	cotton.game = Game()
	cotton.game:load()

	for i, room in pairs(roomDictionary) do
		room:load()
	end

	cotton.player = Player()
	cotton.player:load()

	for i, entity in pairs(entityDictionary) do
		entity:load()
	end

	cotton.game:start()

	goto_level(level_name)

	if config.cameraFollowOverflowImage ~= nil then
		backgroundImg = playdate.graphics.image.new(config.cameraFollowOverflowImage, screenWidth, screenHeight)
	elseif config.cameraFollowOverflowColor == "black" then
		backgroundImg = playdate.graphics.image.new(screenWidth, screenHeight, black)
	end
end

function goto_level(level_name, direction)
	if not level_name then
		return
	end

	if roomDictionary[level_name] then
		cotton.room = roomDictionary[level_name]()
	else
		cotton.room = RoomTemplate()
	end

	local previous_level = game.level_name

	if previous_level then
		cotton.game:exit()
		cotton.room:exit()
		for i, activeEntity in pairs(cotton.activeEntities) do
			activeEntity:exit()
		end
		cotton.player:exit()

		cotton.activeEntities = {}
	end

	game.level_name = level_name
	LDtk.load_level(level_name)

	-- we release the previous level after loading the new one so that it doesn't unload the tileset if we reuse it
	LDtk.release_level(previous_level)

	cotton.game:enter()
	cotton.room:enter()

	playdate.graphics.sprite.removeAll()

	game.tilemap = LDtk.create_tilemap(level_name)

	_background_sprite:setTilemap(game.tilemap)
	_background_sprite:moveTo(0, 0)
	_background_sprite:setCenter(0, 0)
	_background_sprite:setZIndex(-1)
	_background_sprite:add()

	playdate.graphics.sprite.addWallSprites(game.tilemap, LDtk.get_empty_tileIDs(level_name, "Solid"))
	playdate.graphics.sprite.setBackgroundDrawingCallback(game.drawBackground)

	game.player = adapterDictionary[config.playerType]()

	local opposites = {}
	opposites["North"] = "South"
	opposites["South"] = "North"
	opposites["West"] = "East"
	opposites["East"] = "West"

	for index, entity in ipairs(LDtk.get_entities(level_name)) do
		if entity.name == "Exit" then
			if entity.fields.EntranceDirection == opposites[direction] then
				game.player:Init(entity)
			end
		end

		if entity.name == "Player" then
			if direction == nil then
				game.player:Init(entity)
			end
		end

		if entityDictionary[entity.name] then
			local newEntity = entityDictionary[entity.name](entity)
			newEntity:enter()
			cotton.activeEntities[entity.id] = newEntity
		end
	end

	cotton.player:enter()
	-- playdate.graphics.sprite.setAlwaysRedraw(true)
end

function game.freeze()
	game.player:freeze()
end

function game.unfreeze()
	game.player:unfreeze()
end

function game.shutdown()
	_background_sprite:remove()
	LDtk.release_level(game.level_name)
end

function game.update()
	cotton.player:draw()
	cotton.game:loop()
	game.player:Update()

	playdate.graphics.sprite.update()
	cotton.menuHandler:Update()
	cotton.messageHandler:Update()
	cotton.eventHandler:Update()
end

function game.drawBackground(x, y, w, h)
	if backgroundImg == nil then
		return
	end

	-- game.tilemap:draw(0,0, playdate.geometry.rect.new(x,y,w,h))
	backgroundImg:draw(0, 0)
end
