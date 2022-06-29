local gfx <const> = playdate.graphics

class("EntityTemplate", {
    onTile = false,
    collisionType = collisionTypes.default,
    isAnimated = false
}).extends(gfx.sprite)

function EntityTemplate:init(ldtk_entity)
    self.id = ldtk_entity.id
    self.type = "entity"
    self.size = ldtk_entity.size

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

function EntityTemplate:remove()
    self.isRemoved = true
    EntityTemplate.super.remove(self)
end

function EntityTemplate:setImage(src, options)
    local options = options or {}
    if options.animated then
        self.animation = gfx.animation.loop.new(options.delay, gfx.imagetable.new(src), options.loop)
        self.isAnimated = true
        self.image = gfx.image.new(self.size.width, self.size.height)
        EntityTemplate.super.setImage(self, self.image)
        return
    end

    EntityTemplate.super.setImage(self, gfx.imagetable.new(src):getImage(1))
end

function EntityTemplate:animate()
    playdate.graphics.pushContext(self.image)
    playdate.graphics.clear(gfx.kColorClear)
    self.animation:draw(0, 0)
    playdate.graphics.popContext()
end

function EntityTemplate:shouldDraw()
    return self.isAnimated or self.isRemoved == false
end
