function say(message, x, y, width, height, callback)
    -- workaround to use multiple structures
    if (type(x) == "function") then
        callback = x
        x = nil
    end
    -- workaround to use multiple structures
    if (type(width) == "function") then
        callback = width
        width = nil
    end

    local event = function()
        cotton.messageHandler:new(message, x, y, width, height)
    end

    cotton.eventHandler:registerCallback({
        event = event,
        callback = callback or nil
    })
end

function fin(message)
    local event = function()
        cotton.messageHandler:new(message)
    end

    local callback = function()
        cotton.game:finish()
    end

    cotton.eventHandler:registerCallback({
        event = event,
        callback = callback or nil
    })
end

function menu(x, y, width, height, options)
    -- workaround to use multiple structures
    if (type(x) == "table") then
        options = x
        x = nil
    end

    -- workaround to use multiple structures
    if (type(width) == "table") then
        options = width
        width = nil
    end

    local event = function()
        cotton.menuHandler:new(x, y, width, height, options)
    end

    cotton.eventHandler:registerCallback({
        event = event
    })
end

function sound(fileName, volume)
    local fp = playdate.sound.fileplayer.new("sounds/" .. fileName)
    fp:setVolume(volume or 1.0)
    fp:play(1)
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
        "boolean" then
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
    return entity.collisionType == "solid"
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

function window(x, y, width, height)
    return Dialog(x, y, width, height)
end
