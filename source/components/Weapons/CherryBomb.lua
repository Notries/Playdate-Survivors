-- CHERRY BOMB:
-- child of "Bullet"
-- handles physics and drawing of cherry bomb weapon
-- Updated by Player.lua

import "Bullet"

CherryBomb = {}
class("CherryBomb").extends("Bullet")

-- returns true if the CherryBomb is off screen. Otherwise, returns false
function CherryBomb:shouldRemove()
    return CherryBomb.super.shouldRemove(self)
end

function CherryBomb:setValues(__x, __y, __velocityModifier, __flipped, __arrayIndex)
    CherryBomb.super.setValues(self, __x, __y, __velocityModifier, __velocityModifier, __arrayIndex)
    -- bullet variables
    self.bulletAccelerationY = 0.05 * __velocityModifier
	self.bulletVelocityX = 0.5 * __velocityModifier
    if __flipped then
        self.bulletVelocityX = self.bulletVelocityX * -1
    end
    self.bulletVelocityY = -1.5 * __velocityModifier
end

function CherryBomb:init(__x, __y, __velocityModifier, __flipped, __arrayIndex)
	CherryBomb.super.init(self, __x, __y, __velocityModifier, __velocityModifier, __arrayIndex)
    self:setValues(__x, __y, __velocityModifier, __flipped, __arrayIndex)
end

function CherryBomb:update()
    CherryBomb.super.update(self)

    if not(self.upgradeMenuOpened) then
        -- update velocityY based on acceleration
        self.bulletVelocityY = self.bulletVelocityY + self.bulletAccelerationY
    end
end