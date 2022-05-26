local gfx <const> = playdate.graphics

class(
    "EntityTemplate",
    {
        onTile = false,
        collisionType = "solid"
    }
).extends(gfx.sprite)

function EntityTemplate:init(ldtk_entity)
    self.id = ldtk_entity.id
    self.type = "entity"

    self:setZIndex(ldtk_entity.zIndex)
    self:moveTo(ldtk_entity.position.x, ldtk_entity.position.y)
    self:setCenter(ldtk_entity.center.x, ldtk_entity.center.y)
    self:setCollideRect(0, 0, ldtk_entity.size.width, ldtk_entity.size.height)
    self:add()
end

function EntityTemplate:setCollisionType(collisionType)
    self.collisionType = collisionType
end

function EntityTemplate:load()
end

function EntityTemplate:onTileExit()
    self.onTile = false
end

function EntityTemplate:onTileEnter()
    if self.onTile then
        return
    end
    self.onTile = true
    self:collect()
end

function EntityTemplate:enter()
end

function EntityTemplate:collect()
end

function EntityTemplate:interact()
end

function EntityTemplate:exit()
end
