-- PLAYER:
-- handles player movement, crank aiming
-- handles creation, updating, and destruction of bullets/weapons and direction indicator
-- Updated by scene

import "Weapons/Bullet"
import "DirectionIndicator"
import "Weapons/CherryBomb"
import "Weapons/MushroomGuardian"
import "Weapons/BananaBoomerang"

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
	self.playerY = 120
	self.playerVelocity = 0.6
	self.playerVelocityX = 0
	self.playerVelocityY = -0.5
	-- collision
	self:setCollideRect(2, 2, self.playerSizeX - 4, self.playerSizeY - 4)
	-- general weapon variables
    self.tick = 0
	self.bulletSpeedModifier = 1
	---- NOTE: smaller is faster
	self.fireRate = 100
    self.bullets = {}
	-- cherryBomb variables
	self.cherryBombEnabled = false
	self.cherryBombTick = 0
	self.cherryBombThreshold = 2
	-- mushroomGuardian variables
	self.mushroomGuardianEnabled = false
	self.mushroomGuardianTick = 0
	self.mushroomGuardianThreshold = 3
	self.totalMushrooms = 0
	self.mushroomsToRespawn = 0
	-- bananaBoomerang variables
	self.bananaBoomerangEnabled = false
	self.bananaBoomerangTick = 0
	self.bananaBoomerangThreshold = 2
	-- direction indicator variables
	self.directionIndicator = DirectionIndicator()
	-- upgrade menu variables
	self.upgradeMenuOpened = false

	-- sound
	self.shootSound = playdate.sound.sampleplayer.new("assets/sound/laserShoot")
	printTable(self.shootSound)

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
		if (self.tick >= self.fireRate) then
			self.cherryBombTick = self.cherryBombTick + 1
			self.mushroomGuardianTick = self.mushroomGuardianTick + 1
			self.bananaBoomerangTick = self.bananaBoomerangTick + 1
			self.tick = 0
			local len = #self.bullets+1

			-- normal bullet
			self.bullets[len] = Bullet(
				self.playerX,
				self.playerY + self.playerSizeY / 2,
				self.playerVelocityX / self.playerVelocity * 0.5,
				self.playerVelocityY / self.playerVelocity * 0.5,
				len)
			self.bullets[len]:add(self.playerX, self.playerY + self.playerSizeY / 2)
			self.bullets[len]:play()
			self.shootSound:play(1, 1)

			-- banana boomerang
			if self.bananaBoomerangEnabled and self.bananaBoomerangTick%self.bananaBoomerangThreshold == 0 then
				self.bananaBoomerangTick = 0
				
				len = len + 1
				self.bullets[len] = BananaBoomerang(
					self.playerX,
					self.playerY + self.playerSizeY / 2,
					self.playerVelocityX / self.playerVelocity * 0.5,
					self.playerVelocityY / self.playerVelocity * 0.5,
					len,
					false,
					self)
				self.bullets[len]:add(self.playerX, self.playerY + self.playerSizeY / 2)
				self.bullets[len]:play()

				len = len + 1
				self.bullets[len] = BananaBoomerang(
					self.playerX,
					self.playerY + self.playerSizeY / 2,
					self.playerVelocityX / self.playerVelocity * 0.5,
					self.playerVelocityY / self.playerVelocity * 0.5,
					len,
					true,
					self)
				self.bullets[len]:add(self.playerX, self.playerY + self.playerSizeY / 2)
				self.bullets[len]:play()
			end

			-- mushroom guardian
			if self.mushroomGuardianEnabled and self.mushroomGuardianTick%self.mushroomGuardianThreshold == 0 and self.mushroomsToRespawn > 0 then
				self.mushroomGuardianTick = 0
				self.mushroomsToRespawn = self.mushroomsToRespawn - 1

				len = len + 1
				self.bullets[len] = MushroomGuardian(
					self.playerX,
					self.playerY + self.playerSizeY / 2,
					self.playerVelocityX / self.playerVelocity * 0.5,
					self.playerVelocityY / self.playerVelocity * 0.5,
					false,
					len,
					self)
				self.bullets[len]:add(self.playerX, self.playerY + self.playerSizeY / 2)
				self.bullets[len]:play()

				if self.mushroomsToRespawn > 0 then
					self.mushroomsToRespawn = self.mushroomsToRespawn - 1
					len = len + 1
					self.bullets[len] = MushroomGuardian(
						self.playerX,
						self.playerY + self.playerSizeY / 2,
						self.playerVelocityX / self.playerVelocity * 0.5,
						self.playerVelocityY / self.playerVelocity * 0.5,
						true,
						len,
						self)
					self.bullets[len]:add(self.playerX, self.playerY + self.playerSizeY / 2)
					self.bullets[len]:play()
				end
			end

			-- cherry bomb
			if self.cherryBombEnabled and self.cherryBombTick%self.cherryBombThreshold == 0 then
				self.cherryBombTick = 0

				len = len + 1
				self.bullets[len] = CherryBomb(
					self.playerX,
					self.playerY + self.playerSizeY / 2,
					self.bulletSpeedModifier,
					true,
					len)
				self.bullets[len]:add(self.playerX, self.playerY + self.playerSizeY / 2)
				self.bullets[len]:play()

				len = len + 1
				self.bullets[len] = CherryBomb(
					self.playerX,
					self.playerY + self.playerSizeY / 2,
					self.bulletSpeedModifier,
					false,
					len)
				self.bullets[len]:add(self.playerX, self.playerY + self.playerSizeY / 2)
				self.bullets[len]:play()
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
	self:setCollideRect(2, 2, self.playerSizeX - 4, self.playerSizeY - 4)

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

