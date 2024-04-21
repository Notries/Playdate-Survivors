-- BANANA BOOMERANG:
-- child of "Bullet"
-- handles physics and drawing of banana boomerang weapon
-- Updated by Player.lua

import "Bullet"

BananaBoomerang = {}
class("BananaBoomerang").extends("Bullet")

-- returns true if the BananaBoomerang is off screen. Otherwise, returns false
function BananaBoomerang:shouldRemove()
    return BananaBoomerang.super.shouldRemove(self)
end

function BananaBoomerang:setValues(__x, __y, __velocityX, __velocityY, __swapped, __arrayIndex, __player)
    BananaBoomerang.super.setValues(self, __x, __y, __velocityX, __velocityY, __arrayIndex)
    -- bullet variables
    self.bulletVelocity = 4
    self.bulletAcceleration = 1.75
    self.bulletAccelerationY = 0
    self.bulletAccelerationX = 0
    self.bulletVelocityX = 0
    self.bulletVelocityY = 0
    self.bulletX = __x + __velocityX * 20
    self.bulletY = __y + __velocityY * 20
    self.velocityModifierX  = __velocityX
    self.velocityModifierY  = __velocityY
    self.destructionThreshold = 150
    -- self.velocityCapX = 0
    -- self.velocityCapY = 0
    -- self.velocityMinX = 0.05
    -- self.velocityMinY = 0.05
    self.currentCrankPosition = 0
    -- self.destroyed?
    self.destroyed = false
    self.uninitalized = true
    self.banana = true
end

function BananaBoomerang:setup(__swapped, __player)
    -- player variables
    self.player = __player
    self.swapped = __swapped
end

function BananaBoomerang:init(__x, __y, __velocityX, __velocityY, __arrayIndex, __swapped, __player)
	BananaBoomerang.super.init(self, __x, __y, __velocityX, __velocityY, __arrayIndex)
    self:setup(__swapped, __player)
end

function BananaBoomerang:update()
    BananaBoomerang.super.update(self)

    if not(self.upgradeMenuOpened) then
        if (self.uninitalized == true) then
            local adjustment = 15
            if self.swapped then
                adjustment = adjustment * -1
            end
            self.uninitalized = false
            self.currentCrankPosition = math.rad((playdate.getCrankPosition() + adjustment) % 360)
            self.bulletVelocityX = math.sin(self.currentCrankPosition) * self.bulletVelocity
            self.bulletVelocityY = math.cos(self.currentCrankPosition) * self.bulletVelocity * -1
            if self.bulletVelocityX < 0 then
                self.bulletX = self.bulletX - self.player.playerSizeX
            else
                self.bulletX = self.bulletX + self.player.playerSizeX
            end
            if self.bulletVelocityY < 0 then
                self.bulletY = self.bulletY - self.player.playerSizeX * 2 / 3
            else
                -- purposefully using playerSizeX to avoid weirdness with the arc
                -- does that defeat the purpose of this to avoid early collisions? yes
                self.bulletY = self.bulletY + self.player.playerSizeX * 2 / 3
            end

            self:moveTo(self.bulletX, self.bulletY)
        end

        local playerX = self.player.playerX + self.player.playerSizeX / 2 + self.player.playerVelocityX
        local playerY = self.player.playerY + self.player.playerSizeY / 2 + self.player.playerVelocityY
        
        local differenceX = playerX - self.bulletX
        local differenceY = playerY - self.bulletY
        local totalDifference = math.sqrt(differenceX^2 + differenceY^2)
        local accelerationRatio = self.bulletAcceleration / totalDifference

        -- update acceleration based on player position
        self.bulletAccelerationX = differenceX * accelerationRatio / self.player.playerSizeX
        self.bulletAccelerationY = differenceY * accelerationRatio / self.player.playerSizeX

        -- update velocity based on acceleration
        self.bulletVelocityX = self.bulletVelocityX + self.bulletAccelerationX
        self.bulletVelocityY = self.bulletVelocityY + self.bulletAccelerationY
    end
end