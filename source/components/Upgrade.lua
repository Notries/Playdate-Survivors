Upgrade = {}
class("Upgrade").extends(NobleSprite)

function Upgrade:setValues(__x, __y)
    -- identifier
	self.type = 'Upgrade'
    -- upgrade animation
    self.animation:addState("upgrade", 1, 1)
	self.animation:setState("upgrade")
    --- upgrade variables
    self.upgradeSizeX = 13
    self.upgradeSizeY = 13
    self.upgradeX = __x
    self.upgradeY = __y
    self.collected = false
    -- collision
    self:setCollideRect(0, 0, self.upgradeSizeX, self.upgradeSizeY)

    if self.upgradeX > (400 - self.upgradeSizeX) then
        self.upgradeX = 400 - self.upgradeSizeX
    elseif self.upgradeX < self.upgradeSizeX then
        self.upgradeX = self.upgradeSizeX
    end

    if self.upgradeY > (240 - self.upgradeSizeY) then
        self.upgradeY = 240 - self.upgradeSizeY
    elseif self.upgradeY < self.upgradeSizeY then
        self.upgradeY = self.upgradeSizeY
    end
end

function Upgrade:init(__x, __y)
	Upgrade.super.init(self, "assets/images/directionIndicator", true)
    self:setValues(__x, __y)
end

function Upgrade:update()
    if (self.collected) then
        self:remove()
    else
        self:draw(self.upgradeX, self.upgradeY, false) 
    end
end