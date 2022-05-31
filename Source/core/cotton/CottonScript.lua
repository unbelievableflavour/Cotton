local gfx <const> = playdate.graphics

function say(message, positionAndSize, callback)
    positionAndSize = positionAndSize or at()

    cotton.messageHandler:new(message, {
        x = positionAndSize.x,
        y = positionAndSize.y,
        w = positionAndSize.w,
        h = positionAndSize.h,
        afterClose = callback
    })
    cotton.keyListener:setCurrentKeyListener(
        function() cotton.messageHandler:detectInput() end
    )
end

function ask(message, positionAndSize, callback)
    positionAndSize = positionAndSize or at()

    cotton.messageHandler:new(message, {
        x = positionAndSize.x,
        y = positionAndSize.y,
        w = positionAndSize.w,
        h = positionAndSize.h,
        options = callback
    })
    cotton.keyListener:setCurrentKeyListener(
        function() cotton.messageHandler:detectInput() end
    )
end

function fin(message)

    cotton.messageHandler:new(message, {
        afterClose = function() cotton.game:finish() end
    })
    cotton.keyListener:setCurrentKeyListener(
        function() cotton.messageHandler:detectInput() end
    )
end

function menu(positionAndSize, options)
    cotton.menuHandler = MenuHandler({
        x = positionAndSize.x,
        y = positionAndSize.y,
        w = positionAndSize.w,
        h = positionAndSize.h,
        options = options
    }, function() end)
    cotton.keyListener:setCurrentKeyListener(
        function() cotton.menuHandler:detectInput() end
    )
end

function sound(fileName, volume)
    local sp = playdate.sound.fileplayer.new("sounds/" .. fileName)
    sp:setVolume(volume or 1.0)
    sp:play(1)
end

function once(fileName)
    cotton.songPlayer:once(fileName)
end

function loop(fileName)
    cotton.songPlayer:loop(fileName)
end

function stop()
    cotton.songPlayer:stop()
end

function tell(tileId)
    return cotton.activeEntities[tileId]
end

function dump()
    log({
        config = config,
        save = save
    })
end

function store()
    playdate.datastore.write(save, "store", true)
end

function restore()
    save = playdate.datastore.read("store")
end

function toss()
    playdate.datastore.delete("store")
end

function log(node)
    if type(node) == "string" or type(node) == "nil" or type(node) == "number" or type(node) == "userdata" or type(node) ==
        "boolean" or type(node) == "function" then
        print(node)
        return
    end

    local cache, stack, output = {}, {}, {}
    local depth = 1
    local output_str = "{\n"

    while true do
        local size = 0

        for k, v in pairs(node) do
            size = size + 1
        end

        local cur_index = 1
        for k, v in pairs(node) do
            if (cache[node] == nil) or (cur_index >= cache[node]) then
                if (string.find(output_str, "}", output_str:len())) then
                    output_str = output_str .. ",\n"
                elseif not (string.find(output_str, "\n", output_str:len())) then
                    output_str = output_str .. "\n"
                end

                -- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings
                table.insert(output, output_str)
                output_str = ""

                local key
                if (type(k) == "number" or type(k) == "boolean") then
                    key = "[" .. tostring(k) .. "]"
                else
                    key = "['" .. tostring(k) .. "']"
                end

                if (type(v) == "number" or type(v) == "boolean") then
                    output_str = output_str .. string.rep("\t", depth) .. key .. " = " .. tostring(v)
                elseif (type(v) == "table") then
                    output_str = output_str .. string.rep("\t", depth) .. key .. " = {\n"
                    table.insert(stack, node)
                    table.insert(stack, v)
                    cache[node] = cur_index + 1
                    break
                else
                    output_str = output_str .. string.rep("\t", depth) .. key .. " = '" .. tostring(v) .. "'"
                end

                if (cur_index == size) then
                    output_str = output_str .. "\n" .. string.rep("\t", depth - 1) .. "}"
                else
                    output_str = output_str .. ","
                end
            else
                -- close the table
                if (cur_index == size) then
                    output_str = output_str .. "\n" .. string.rep("\t", depth - 1) .. "}"
                end
            end

            cur_index = cur_index + 1
        end

        if (size == 0) then
            output_str = output_str .. "\n" .. string.rep("\t", depth - 1) .. "}"
        end

        if (#stack > 0) then
            node = stack[#stack]
            stack[#stack] = nil
            depth = cache[node] == nil and depth + 1 or depth - 1
        else
            break
        end
    end

    -- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings
    table.insert(output, output_str)
    output_str = table.concat(output)

    print(output_str)
end

function invert()
    local isInverted = playdate.display.getInverted()
    playdate.display.setInverted(not isInverted)

    return not isInverted
end

function isSolid(entity)
    return entity.collisionType ~= collisionTypes.overlap
end

function datetime()
    return playdate.getTime()
end

function timestamp()
    return playdate.getSecondsSinceEpoch()
end

function hidePlayer()
    game.player.sprite:remove()
end

function showPlayer()
    game.player.sprite:add()
end

function wait(delay, callback)
    playdate.timer.performAfterDelay(delay, callback)
end

function ignore()
    game.player:freeze()
end

function listen()
    game.player:unfreeze()
end

function act()
    game.player:act()
end

function window(positionAndSize)
    return Dialog(
        positionAndSize.x,
        positionAndSize.y,
        positionAndSize.w,
        positionAndSize.h
    )
end

function label(message, positionAndSize)
    gfx.setFont(cotton.textFont)

    gfx.drawTextInRect(
        message,
        positionAndSize.x,
        positionAndSize.y,
        positionAndSize.w or screenWidth,
        positionAndSize.h or screenHeight
    )
end

function fillRect(color, positionAndSize)
    gfx.setColor(color)
    gfx.fillRect(
        positionAndSize.x,
        positionAndSize.y,
        positionAndSize.w,
        positionAndSize.h
    )
end

function fillCircle(color, positionAndSize)
    gfx.setColor(color)
    gfx.fillCircleAtPoint(
        positionAndSize.x,
        positionAndSize.y,
        positionAndSize.w
    )
end

function sprite(path, positionAndSize)
    local image = playdate.graphics.image.new(path)
    local sprite = playdate.graphics.sprite.new(image)
    sprite:moveTo(positionAndSize.x, positionAndSize.y)
    sprite:setCenter(positionAndSize.x / 2, positionAndSize.y / 2)
    return sprite
end

function at(x, y, w, h)
    local positionAndSize = {
        x = x or nil,
        y = y or nil,
        w = w or nil,
        h = h or nil
    }

    return positionAndSize
end
