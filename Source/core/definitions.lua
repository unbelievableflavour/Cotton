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

        if config.cameraFollowLockY then
            return playdate.geometry.point.new(
                spriteX - (screenWidth / 2) - config.cameraFollowOffsetX,
                0 - config.cameraFollowOffsetY
            )
        end

        if config.cameraFollowLockX then
            return playdate.geometry.point.new(
                0 + config.cameraFollowOffsetX,
                spriteY - (screenHeight / 2) - config.cameraFollowOffsetY
            )
        end

        return playdate.geometry.point.new(
            spriteX - (screenWidth / 2) - config.cameraFollowOffsetX,
            spriteY - (screenHeight / 2) - config.cameraFollowOffsetY
        )
    end

    return playdate.geometry.point.new(0, 0)
end
