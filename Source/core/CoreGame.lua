local gfx <const> = playdate.graphics

game = {}
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

local _background_sprite = gfx.sprite.new()
local backgroundImg = nil

function game.init(level_name)
    cotton.textFont = gfx.font.new("fonts/" .. config.font)
    cotton.textFontHeight = cotton.textFont:getHeight()

    cotton.songPlayer = SongPlayer()
    cotton.keyListener = KeyListener()
    cotton.messageHandler = MessageHandler()
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
        backgroundImg = gfx.image.new(config.cameraFollowOverflowImage, screenWidth, screenHeight)
    elseif config.cameraFollowOverflowColor == "black" then
        backgroundImg = gfx.image.new(screenWidth, screenHeight, black)
    end
end

function goto_level(level_name, direction)
    if not level_name then
        return
    end

    local previous_level = game.level_name
    local previousPlayerPosition = {
        x = nil,
        y = nil,
    }
    local previousRoomDimensions = nil

    if previous_level then
        local backupX, backupY = game.player.sprite:getPosition()
        previousPlayerPosition.x = backupX
        previousPlayerPosition.y = backupY
        previousRoomDimensions = cotton.room
        cotton.game:exit()
        cotton.room:exit()
        for i, activeEntity in pairs(cotton.activeEntities) do
            activeEntity:exit()
        end
        cotton.player:exit()

        cotton.activeEntities = {}
    end

    if roomDictionary[level_name] then
        cotton.room = roomDictionary[level_name]()
    else
        cotton.room = RoomTemplate()
    end

    game.level_name = level_name
    LDtk.load_level(level_name)

    local newDimensions = LDtk.get_level_dimensions(level_name, "Tiles")
    cotton.room:setDimensions(newDimensions, previousRoomDimensions)

    -- we release the previous level after loading the new one so that it doesn't unload the tileset if we reuse it
    LDtk.release_level(previous_level)

    cotton.game:enter()
    cotton.room:enter()

    gfx.sprite.removeAll()

    game.tilemap = LDtk.create_tilemap(level_name)

    _background_sprite:setTilemap(game.tilemap)
    _background_sprite:moveTo(0, 0)
    _background_sprite:setCenter(0, 0)
    _background_sprite:setZIndex(-1)
    _background_sprite:add()

    gfx.sprite.addWallSprites(game.tilemap, LDtk.get_empty_tileIDs(level_name, "Solid"))
    gfx.sprite.setBackgroundDrawingCallback(game.drawBackground)

    game.player = adapterDictionary[config.playerType]()

    local opposites = {}
    opposites["North"] = "South"
    opposites["South"] = "North"
    opposites["West"] = "East"
    opposites["East"] = "West"

    for index, entity in ipairs(LDtk.get_entities(level_name)) do
        -- if player came from other room
        if entity.name == "Exit" then
            if entity.fields.EntranceDirection == opposites[direction] then
                game.player:Init(entity)
                game.player.faceDirection = string.lower(direction)

                if opposites[direction] == "North" then
                    game.player:moveTo(
                        previousPlayerPosition.x - cotton.room.offsetFromPreviousRoom.x,
                        0
                    )
                end

                if opposites[direction] == "South" then
                    game.player:moveTo(
                        previousPlayerPosition.x - cotton.room.offsetFromPreviousRoom.x,
                        cotton.room.h - game.player.sprite.height
                    )
                end

                if opposites[direction] == "East" then
                    game.player:moveTo(
                        cotton.room.w - game.player.sprite.width,
                        previousPlayerPosition.y - cotton.room.offsetFromPreviousRoom.y
                    )
                end

                if opposites[direction] == "West" then
                    game.player:moveTo(
                        0,
                        previousPlayerPosition.y - cotton.room.offsetFromPreviousRoom.y
                    )
                end
            end
        end

        -- if player just started the game
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
    -- gfx.sprite.setAlwaysRedraw(true)
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
    gfx.sprite.update()

    cotton.player:draw()
    cotton.game:loop()
    game.player:update()

    cotton.keyListener:update()
    cotton.messageHandler:update()
end

function game.drawBackground(x, y, w, h)
    if backgroundImg == nil then
        return
    end

    -- game.tilemap:draw(0,0, playdate.geometry.rect.new(x,y,w,h))
    backgroundImg:draw(0, 0)
end
