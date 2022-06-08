--[[
	!Important! playdate.buttonIsPressed always return the current state of the buttons.
	That means that  playdate.buttonIsPressed(playdate.kButtonA) might not return the same values at different places in the update function
	That can potentially lead to unexpected bugs if some state expect the same values. This library makes sure that values a consistant througout the frame
]] --
buttonLeft = playdate.kButtonLeft
buttonRight = playdate.kButtonRight
buttonUp = playdate.kButtonUp
buttonDown = playdate.kButtonDown
buttonA = playdate.kButtonA
buttonB = playdate.kButtonB

function getRepeatDuration()
    if not config.inputRepeat then
        return 60
    end

    return config.inputRepeatBetween
end

input = {
    repeatDuration = getRepeatDuration(),
    repeats = {
        [buttonLeft] = {
            state = false,
            timer = 0
        },
        [buttonRight] = {
            state = false,
            timer = 0
        },
        [buttonUp] = {
            state = false,
            timer = 0
        },
        [buttonDown] = {
            state = false,
            timer = 0
        },
        [buttonA] = {
            state = false,
            timer = 0
        },
        [buttonB] = {
            state = false,
            timer = 0
        }
    },

    isCrankDocked = {
        previous = nil,
        current = nil
    },

    is_recording = true
}

local _buttonFrameState = 0

-- input.is = playdate.buttonIsPressed
input.justPressed = playdate.buttonJustPressed
input.justReleased = playdate.buttonJustReleased

function input.onRepeat(buttonId)
    return input.repeats[buttonId].state
end

function input.update(dt)
    dt = dt or (1 / playdate.display.getRefreshRate())

    -- Save the button for this frame because playdate.buttonIsPressed always return latest result
    local isPressed = playdate.buttonIsPressed
    _buttonFrameState = 0
    if isPressed(playdate.kButtonA) then
        _buttonFrameState = _buttonFrameState | playdate.kButtonA
    end
    if isPressed(playdate.kButtonB) then
        _buttonFrameState = _buttonFrameState | playdate.kButtonB
    end
    if isPressed(playdate.kButtonUp) then
        _buttonFrameState = _buttonFrameState | playdate.kButtonUp
    end
    if isPressed(playdate.kButtonDown) then
        _buttonFrameState = _buttonFrameState | playdate.kButtonDown
    end
    if isPressed(playdate.kButtonLeft) then
        _buttonFrameState = _buttonFrameState | playdate.kButtonLeft
    end
    if isPressed(playdate.kButtonRight) then
        _buttonFrameState = _buttonFrameState | playdate.kButtonRight
    end

    for buttonId, buttonRepeat in pairs(input.repeats) do
        buttonRepeat.timer = buttonRepeat.timer + dt

        if input.justPressed(buttonId) or (input.is(buttonId) and buttonRepeat.timer > input.repeatDuration) then
            buttonRepeat.state = true
            buttonRepeat.timer = 0
        elseif input.is(buttonId) == false then
            buttonRepeat.state = false
            buttonRepeat.timer = 0
        else
            buttonRepeat.state = false
        end
    end

    local isCrankDocked = input.isCrankDocked
    isCrankDocked.previous = isCrankDocked.current
    isCrankDocked.current = playdate.isCrankDocked()
end

function input.is(button)
    return (_buttonFrameState & button) ~= 0
end

function input.x()
    local r = 0
    if input.is(buttonLeft) then
        r = r - 1
    end
    if input.is(buttonRight) then
        r = r + 1
    end
    return r
end

function input.y()
    local r = 0
    if input.is(buttonUp) then
        r = r - 1
    end
    if input.is(buttonDown) then
        r = r + 1
    end
    return r
end

function input.getCrankAngle()
    return playdate.getCrankPosition()
end

function input.isCranking()
    return playdate.getCrankChange() ~= 0.0
end

function input.onCrankDock()
    local isCrankDocked = input.isCrankDocked
    return isCrankDocked.previous == false and isCrankDocked.current == true
end

function input.onCrankUndock()
    local isCrankDocked = input.isCrankDocked
    return isCrankDocked.previous == true and isCrankDocked.current == false
end

function input.reset()
    for buttonId, buttonRepeat in pairs(input.repeats) do
        buttonRepeat.state = false
        buttonRepeat.timer = 0
    end
end
