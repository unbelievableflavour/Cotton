class("Computer", {}).extends(EntityTemplate)
-- Wanna know what events are called on the entities? Check EntityTemplate!

function Computer:init(ldtk_entity)
    Computer.super.init(self, ldtk_entity)

    self:setImage(asset("computer"))
end

function Computer:interact()
    if disks == 0 then
        say("You could play a game on this old computer if you had all of the floppies...")
        return
    end

    if disks == 1 then
        say("You've found 1 floppy disk.")
        return
    end

    if disks == 4 then
        say("You've found all the floppy disks!", at(), function()
            fin("You whiled away the afternoon on the computer. The End")
        end)
        return
    end

    say("You've found " .. disks .. " floppy disks.")
end
