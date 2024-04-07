Player = {}
class("Player").extends(NobleSprite)

function Player:stopPlayer()
	self.buttonHeld = true
	self.animation:setState("idle")
end

function Player:goPlayer()
	self.buttonHeld = false
	self.animation:setState("walk")
end

function Player:setValues()
    self.animation:addState("idle", 1, 1)
	self.animation:addState("walk", 1, 3, nil, nil, nil, 10)
	self.animation:addState("jump", 4, 6, nil, false, nil, 10)
	self.animation:setState("idle")
	self.playerX = 200
	self.playerY = 200
	self.playerVelocity = 0.5
	self.playerVelocityX = 0
	self.playerVelocityY = 1
    self:goPlayer()
end

function Player:init()
	Player.super.init(self, "assets/images/player", true)
    self:setValues()
end

function Player:update()
    if (not(self.buttonHeld)) then
		self.currentCrankPosition = math.rad(playdate.getCrankPosition())
		self.playerVelocityX = math.sin(self.currentCrankPosition) * self.playerVelocity
		self.playerVelocityY = math.cos(self.currentCrankPosition) * self.playerVelocity * -1
		self.playerX = self.playerX + self.playerVelocityX
		self.playerY = self.playerY + self.playerVelocityY
		if self.playerVelocityX < 0 then
			self.animation.direction = Noble.Animation.DIRECTION_LEFT
		else
			self.animation.direction = Noble.Animation.DIRECTION_RIGHT
		end
	end
	self:draw(self.playerX, self.playerY, false)
end

