class("Floppy", {}).extends(EntityTemplate)
-- Wanna know what events are called on the entities? Check EntityTemplate!

disks = 0

function Floppy:init(ldtk_entity)
    Floppy.super.init(self, ldtk_entity)

    self:setCollisionType(collisionTypes.overlap)
    self:setImage("images/floppy", { animated = true, delay = 500, loop = true })
end

function Floppy:collect()
    disks = disks + 1
    say("You found a floppy disk!")
    self:remove()
end
