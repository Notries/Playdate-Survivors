Gun {}
class("Gun").extends(NobleSprite)

function Gun:setValues(__velocityX, __velocityY)
    self.animation:addState("bullet", 1, 1)
	self.animation:setState("bullet")
	self.bulletVelocityX = __velocityX
    self.bulletVelocityY = __velocityY
    self:goPlayer()
end

function Gun:init(__x, __y)
	Gun.super.init(self, "assets/images/gun", true)
    self:setValues(__x, __y)
end