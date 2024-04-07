Bullet = {}
class("Bullet").extends(NobleSprite)

-- returns true if the Bullet is off screen. Otherwise, returns false
function Bullet:shouldRemove()
    return (self.bulletX < 0 - self.bulletSizeX or self.bulletX > 400 or self.bulletY < 0 - self.bulletSizeY or self.bulletY > 240 or self.collided)
end

function Bullet:setValues(__x, __y, __velocityX, __velocityY, __arrayIndex)
    -- identifier
	self.type = 'Bullet'
    -- bullet animations
    self.animation:addState("bullet", 1, 1)
	self.animation:setState("bullet")
    -- bullet variables
    self.bulletSpeed = 3.5
    self.bulletSizeX = 13
    self.bulletSizeY = 13
    self.bulletX = __x
    self.bulletY= __y
	self.bulletVelocityX = __velocityX * self.bulletSpeed
    self.bulletVelocityY = __velocityY * self.bulletSpeed
    -- player variables
    self.playerX = __x
    self.playerY = __y
    self.arrayIndex = __arrayIndex
    -- collision
    self:setCollideRect(0, 0, self.bulletSizeX, self.bulletSizeY)
    self.collided = false
end

function Bullet:init(__x, __y, __velocityX, __velocityY, __arrayIndex)
	Bullet.super.init(self, "assets/images/gun", true)
    self:setValues(__x, __y, __velocityX, __velocityY, __arrayIndex)
end

function Bullet:update()
    -- moves the bullet. If the bullet is off screen, remove it from the scene. (The remove statement is maybe not necessary)
    self.bulletX = self.bulletX + self.bulletVelocityX
    self.bulletY = self.bulletY + self.bulletVelocityY
    if (self:shouldRemove()) then
		self:remove()
	else
        self:moveTo(self.bulletX, self.bulletY)
        self:draw(self.bulletX, self.bulletY, false)
        -- collide! (reconverting back to global coordinates)
        self:setCollideRect(0, 0, self.bulletSizeX, self.bulletSizeY)
    end
end