-- MUSHROOM GUARDIAN:
-- child of "Bullet"
-- handles physics and drawing of mushroom guardian weapon
-- Updated by Player.lua

import "Bullet"

MushroomGuardian = {}
class("MushroomGuardian").extends("Bullet")

-- returns true if the MushroomGuardian is off screen. Otherwise, returns false
function MushroomGuardian:shouldRemove()
    if (MushroomGuardian.super.shouldRemove(self)) then
        if (not(self.destroyed)) then
            self.player.mushroomsToRespawn = self.player.mushroomsToRespawn + 1
            self.destroyed = true 
        end
        return true
    end
    return false
end

function MushroomGuardian:setValues(__x, __y, __velocityX, __velocityY, __swapped, __arrayIndex, __player)
    MushroomGuardian.super.setValues(self, __x, __y, __velocityX, __velocityY, __arrayIndex)
    -- bullet variables
    self.bulletAcceleration = 0.295
    self.bulletAccelerationY = 0
    self.bulletAccelerationX = 0
    self.velocityCapX = 0
    self.velocityCapY = 0
    self.velocityMinX = 0.05
    self.velocityMinY = 0.05
    -- self.destroyed?
    self.destroyed = false
end

function MushroomGuardian:setup(__swapped, __player)
    -- player variables
    self.player = __player
    self.swapped = __swapped
end

function MushroomGuardian:init(__x, __y, __velocityX, __velocityY, __swapped, __arrayIndex, __player)
	MushroomGuardian.super.init(self, __x, __y, __velocityX, __velocityY, __arrayIndex)
    self:setup(__swapped, __player)
end

function MushroomGuardian:update()
    MushroomGuardian.super.update(self)
    self.ticks = 0

    if not(self.upgradeMenuOpened) then
        if (self.velocityCapX == 0) then
            self.velocityCapX = self.player.playerSizeX / 16 / 1.5
            self.velocityCapY = self.player.playerSizeY / 16 / 1.5
            self.bulletVelocityX = self.player.playerSizeX / 16 / 3
            self.bulletVelocityY = self.player.playerSizeY / 16 / 3
            if self.swapped then
                self.bulletVelocityX = self.bulletVelocityX * -1
                self.bulletVelocityY = self.bulletVelocityY * -1
            end
        end

        local playerX = self.player.playerX + self.player.playerSizeX / 2
        local playerY = self.player.playerY + self.player.playerSizeY / 2
        
        local differenceX = playerX - self.bulletX
        local differenceY = playerY - self.bulletY
        local totalDifference = math.sqrt(differenceX^2 + differenceY^2)
        local accelerationRatio = self.bulletAcceleration / totalDifference

        -- update acceleration based on player position
        self.bulletAccelerationX = differenceX * accelerationRatio / self.player.playerSizeX
        self.bulletAccelerationY = differenceY * accelerationRatio / self.player.playerSizeY

        -- print("playerX: " .. playerX)
        -- print("playerY: " .. playerY)
        -- print("differenceX: " .. differenceX)
        -- print("differenceY: " .. differenceY)
        -- print("totalDifference: " .. totalDifference)
        -- print("accelerationRatio: " .. accelerationRatio)
        -- print("bulletAccelerationX: " .. self.bulletAccelerationX)
        -- print("bulletAccelerationY: " .. self.bulletAccelerationY)

        -- update velocity based on acceleration
        self.bulletVelocityX = self.bulletVelocityX + self.bulletAccelerationX
        self.bulletVelocityY = self.bulletVelocityY + self.bulletAccelerationY

        if self.bulletVelocityX > self.velocityCapX then
            self.bulletVelocityX = self.velocityCapX
        elseif self.bulletVelocityX < self.velocityMinX and self.bulletVelocityX > 0 then
            self.bulletVelocityX = self.bulletVelocityX * 1.03
        elseif self.bulletVelocityX > self.velocityMinX * -1 and self.bulletVelocityX < 0 then
            self.bulletVelocityX = self.bulletVelocityX * 1.03
        elseif self.bulletVelocityX < self.velocityCapX * -1 then
            self.bulletVelocityX = self.velocityCapX * -1
        end

        if self.bulletVelocityY > self.velocityCapY then
            self.bulletVelocityY = self.velocityCapY
        elseif self.bulletVelocityY < self.velocityMinY and self.bulletVelocityY > 0 then
            self.bulletVelocityY = self.bulletVelocityY * 1.03
        elseif self.bulletVelocityY > self.velocityMinY * -1 and self.bulletVelocityY < 0 then
            self.bulletVelocityY = self.bulletVelocityY * 1.03
        elseif self.bulletVelocityY < self.velocityCapY * -1 then
            self.bulletVelocityY = self.velocityCapY * -1
        end
    end
end