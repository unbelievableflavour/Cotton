class("Player", {}).extends(PlayerTemplate)
-- Wanna know what events are called on player? Check PlayerTemplate!

-- Example:
function Player:confirmPressed()
    local mainMenu = { {
        name = "Option 1",
        callback = (function()
            say("You've selected option 1!")
        end)
    }, {
        name = "Option 2",
        callback = (function()
            say("You've selected option 2!")
        end)
    }, {
        name = "Option 3",
        callback = (function()
            say("You've selected option 3!")
        end)
    }, {
        name = "Option 4",
        callback = (function()
            say("You've selected option 4!")
        end)
    }, {
        name = "Option 5",
        callback = (function()
            say("You've selected option 5!")
        end)
    }, {
        name = "Open Submenu",
        callback = (function()
            say("Not yet implemented")
        end)
    } }

    menu(mainMenu)
end
