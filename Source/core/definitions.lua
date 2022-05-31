local gfx <const> = playdate.graphics

white = gfx.kColorWhite
black = gfx.kColorBlack
screenWidth, screenHeight = playdate.display.getSize()
screenCenterX = screenWidth / 2
screenCenterY = screenHeight / 2
collisionTypes = {
    default = "freeze",
    freeze = "freeze",
    slide = "slide",
    overlap = "overlap",
    bounce = "bounce"
}

function getTopLeftCorner()
    if config.cameraFollow then
        local spriteX, spriteY = game.player.sprite:getPosition()
        return playdate.geometry.point.new(spriteX - (screenWidth / 2), spriteY - (screenHeight / 2))
    end
    return playdate.geometry.point.new(0, 0)
end
