Enemy = {}
class("Enemy").extends(NobleSprite)

function Enemy.getEnemySizeX()
    return 16
end

function Enemy.getEnemySizeY()
    return 32
end

function Enemy:isDead()
    return self.collided
end

function Enemy:setValues(__x, __y, __enemySpawnerX, __enemySpawnerY)
    -- identifier
	self.type = 'Enemy'
    -- enemy animation
    self.animation:addState("walk", 1, 3, nil, nil, nil, 2)
	self.animation:setState("walk")
    --- enemy variables
    self.tick = 0
    self.enemySizeX = self.getEnemySizeX()
    self.enemySizeY = self.getEnemySizeY()
    self.enemyX = __x
    self.enemyY = __y
    self.enemyVelocity = 0.3
    self.enemyVelocityX = 0
    self.enemyVelocityY = 5
    self.spawnerX = __enemySpawnerX
    self.spawnerY = __enemySpawnerY
    -- collision
    self:setCollideRect(0, 0, self.enemySizeX, self.enemySizeY)
    self.collided = false
end

function Enemy:init(__x, __y, __enemySpawnerX, __enemySpawnerY)
	Enemy.super.init(self, "assets/images/player", true)
    self:setValues(__x, __y, __enemySpawnerX, __enemySpawnerY)
end

function Enemy:followPlayer(playerSprite)
    local speedSquared = self.enemyVelocity * self.enemyVelocity
    local xDifferenceSquared = (playerSprite.playerX - self.enemyX) * (playerSprite.playerX - self.enemyX)
    local yDifferenceSquared = (playerSprite.playerY - self.enemyY) * (playerSprite.playerY - self.enemyY)
    local dxIsPositive = playerSprite.playerX - self.enemyX > 0
    local dyIsPositive = playerSprite.playerY - self.enemyY > 0
    local dx = math.sqrt(math.abs(speedSquared * xDifferenceSquared / (xDifferenceSquared + yDifferenceSquared)))
    local dy = math.sqrt(math.abs(speedSquared * yDifferenceSquared / (xDifferenceSquared + yDifferenceSquared)))
    if not(dxIsPositive) then
        dx = dx * -1
    end
    if not(dyIsPositive) then
        dy = dy * -1
    end
    self.enemyVelocityX = dx
    self.enemyVelocityY = dy

    self.tick = self.tick + 1
end

function Enemy:update()
    self.enemyX = self.enemyX + self.enemyVelocityX
    self.enemyY = self.enemyY + self.enemyVelocityY

    if (self:isDead()) then
        self:remove()
    else
        -- draw!
        self:moveTo(self.enemyX, self.enemyY)
        self:draw(self.enemyX, self.enemyY, false)
        -- collide!
        self:setCollideRect(0, 0, self.enemySizeX, self.enemySizeY)
    end
end