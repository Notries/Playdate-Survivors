import 'Bullet'
import "DirectionIndicator"
import "CherryBomb"

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
	-- identifier
	self.type = 'Player'
	-- player animations
    self.animation:addState("idle", 1, 1)
	self.animation:addState("walk", 1, 3, nil, nil, nil, 10)
	self.animation:addState("jump", 4, 6, nil, false, nil, 10)
	-- player variables
	self.playerSizeX = 16
	self.playerSizeY = 32
	self.playerX = 200
	self.playerY = 200
	self.playerVelocity = 0.5
	self.playerVelocityX = 0
	self.playerVelocityY = -0.5
	-- collision
	self:setCollideRect(0, 0, self.playerSizeX, self.playerSizeY)
	-- gun variables
    self.tick = 0
	self.subtick = 0
	self.bulletSpeedModifier = 1
	-- cherryBomb variables
	self.cherryBombEnabled = false
	---- fireRate: smaller is faster
	self.fireRate = 100
    self.bullets = {}
	-- direction indicator variables
	self.directionIndicator = DirectionIndicator()
	-- upgrade menu variables
	self.upgradeMenuOpened = false

	self:goPlayer()
end

function Player:init()
	Player.super.init(self, "assets/images/player", true)
    self:setValues()
end

function Player:update()
	if not(self.upgradeMenuOpened) then
		-- advance the gun clock, and fire a bullet if it's time.
		self.tick = self.tick + 1
		if (self.tick > self.fireRate) then
			self.subtick = self.subtick + 1
			self.tick = 0
			local len = #self.bullets+1

			-- normal bullet
			self.bullets[len] = Bullet(
				self.playerX,
				self.playerY + self.playerSizeY / 2,
				self.playerVelocityX / self.playerVelocity * 0.5 * self.bulletSpeedModifier,
				self.playerVelocityY / self.playerVelocity * 0.5 * self.bulletSpeedModifier,
				len)
			self.bullets[len]:add(self.playerX, self.playerY + self.playerSizeY / 2)
			self.bullets[len]:play()

			-- cherry bomb
			if self.cherryBombEnabled and self.subtick%3 == 0 then
				self.subtick = 0

				math.randomseed(playdate.getSecondsSinceEpoch())
				local flipped = math.random(2)

				self.bullets[len+1] = CherryBomb(
					self.playerX,
					self.playerY + self.playerSizeY / 2,
					self.bulletSpeedModifier,
					true,
					len+1)
				self.bullets[len+1]:add(self.playerX, self.playerY + self.playerSizeY / 2)
				self.bullets[len+1]:play()

				self.bullets[len+2] = CherryBomb(
					self.playerX,
					self.playerY + self.playerSizeY / 2,
					self.bulletSpeedModifier,
					false,
					len+2)
				self.bullets[len+2]:add(self.playerX, self.playerY + self.playerSizeY / 2)
				self.bullets[len+2]:play()
			end
		end
	
		-- check the crank, and change the player's speed to match the direction of the crank.
		self.currentCrankPosition = math.rad(playdate.getCrankPosition())
		self.playerVelocityX = math.sin(self.currentCrankPosition) * self.playerVelocity
		self.playerVelocityY = math.cos(self.currentCrankPosition) * self.playerVelocity * -1
	
		-- adjust the player's position based on their speed.
		if (not(self.buttonHeld)) then
			self.playerX = self.playerX + self.playerVelocityX
			self.playerY = self.playerY + self.playerVelocityY
			if self.playerVelocityX < 0 then
				self.animation.direction = Noble.Animation.DIRECTION_LEFT
			else
				self.animation.direction = Noble.Animation.DIRECTION_RIGHT
			end
		end
	
		-- display the direction indicator in the direction of the player's speed
		self.directionIndicator:updatePosition(self.playerX + self.playerVelocityX / self.playerVelocity * 35, self.playerY + self.playerVelocityY / self.playerVelocity * 35 + self.playerSizeY / 2)
		self.directionIndicator:update()
	
		-- keep the player from escaping the bounds of the screen
		if (self.playerX < 0) then
			self.playerX = 0
		elseif (self.playerX > 400 - self.playerSizeX) then
			self.playerX = 400 - self.playerSizeX
		end
		if (self.playerY < 0) then
			self.playerY = 0
		elseif (self.playerY > 240 - self.playerSizeY) then
			self.playerY = 240 - self.playerSizeY
		end
	
		-- move!
		self:moveTo(self.playerX, self.playerY)
	else
		self.animation:setState("idle")
	end

	-- draw!
	self:draw(self.playerX, self.playerY, false)

	-- collide!
	self:setCollideRect(0, 0, self.playerSizeX, self.playerSizeY)

	-- draw all of the bullets, and remove them if they're going off screen
	for i = 1, #self.bullets do
		local bullet = self.bullets[i]
		if (bullet ~= nil) then
			if self.upgradeMenuOpened then
				bullet.upgradeMenuOpened = true
			else
				bullet.upgradeMenuOpened = false
			end

			if (bullet:shouldRemove()) then
				table.remove(self.bullets, i)
				if i < #self.bullets then
					i = i - 1
				end
			else
				bullet:update()
			end
		end
	end
end

