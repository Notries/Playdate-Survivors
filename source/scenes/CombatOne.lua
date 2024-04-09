-- COMBAT ONE
-- SCENE: enters at start of game and on restart from Game Over
-- Holds the input handler
-- Handles updates for Player, EnemeySpawner, ScoreTracker, and UpgradeMenu
-- Handles all collisions

import '../CoreLibs/crank'
import '../components/Player'
import '../components/EnemySpawner'
import '../components/ScoreTracker'
import '../components/UpgradeMenu'

CombatOne = {}
class("CombatOne").extends(NobleScene)
local scene = CombatOne
scene.backgroundColor = Graphics.kColorWhite

function scene:destroyEnemySpawner()
	self.drawEnemySpawner = false
	self.enemySpawnerSprite:remove()
end

function scene:destroyPlayer()
	self.drawPlayer = false
	self.playerSprite:remove()
	Noble.transition(GameOver, nil, Noble.Transition.Spotlight, {
		invert = true, xEnterStart = 50, yEnterStart = 50, xEnterEnd = self.playerSprite.playerX + self.playerSprite.playerSizeX / 2, yEnterEnd = self.playerSprite.playerY + self.playerSprite.playerSizeY / 2,
	})
end

function scene:setValues()
	-- Directory starts in /source
	self.scoreTracker = ScoreTracker()
	self.playerSprite = Player()
	self.enemySpawnerSprite = EnemySpawner()
	-- Upgrade Menu
	self.upgradeMenuSprite = UpgradeMenu(self)

	self.drawEnemySpawner = true
	self.drawPlayer = true
	self.ticks = 0
end

function scene:init()
	scene.super.init(self)
	self:setValues()

	local crankTick = 0
	scene.inputHandler = {
		-- A button
		--
		AButtonDown = function()			-- Runs once when button is pressed.
			-- Your code here
			self.playerSprite:stopPlayer()
			self.upgradeMenuSprite.menu:click()
		end,
		AButtonHold = function()			-- Runs every frame while the player is holding button down.
			-- Your code here
			self.playerSprite:stopPlayer()
		end,
		AButtonHeld = function()			-- Runs after button is held for 1 second.
			-- Your code here
			self.playerSprite:stopPlayer()
		end,
		AButtonUp = function()				-- Runs once when button is released.
			-- Your code here
			self.playerSprite:goPlayer()
		end,
	
		-- B button
		--
		BButtonDown = function()
			-- Your code here
			self.playerSprite:stopPlayer()
			self.upgradeMenuSprite.menu:click()
		end,
		BButtonHeld = function()
			-- Your code here
			self.playerSprite:stopPlayer()
		end,
		BButtonHold = function()
			-- Your code here
			self.playerSprite:stopPlayer()
		end,
		BButtonUp = function()
			-- Your code here
			self.playerSprite:goPlayer()
		end,
	
		-- D-pad left
		--
		leftButtonDown = function()
			-- Your code here
			self.playerSprite:stopPlayer()
			self.upgradeMenuSprite.menu:click()
		end,
		leftButtonHold = function()
			-- Your code here
			self.playerSprite:stopPlayer()
		end,
		leftButtonUp = function()
			-- Your code here
			self.playerSprite:goPlayer()
		end,
	
		-- D-pad right
		--
		rightButtonDown = function()
			-- Your code here
			self.playerSprite:stopPlayer()
			self.upgradeMenuSprite.menu:click()
		end,
		rightButtonHold = function()
			-- Your code here
			self.playerSprite:stopPlayer()
		end,
		rightButtonUp = function()
			-- Your code here
			self.playerSprite:goPlayer()
		end,
	
		-- D-pad up
		--
		upButtonDown = function()
			-- Your code here
			self.playerSprite:stopPlayer()
			self.upgradeMenuSprite.menu:click()
		end,
		upButtonHold = function()
			-- Your code here
			self.playerSprite:stopPlayer()
		end,
		upButtonUp = function()
			-- Your code here
			self.playerSprite:goPlayer()
		end,
	
		-- D-pad down
		--
		downButtonDown = function()
			-- Your code here
			self.playerSprite:stopPlayer()
			self.upgradeMenuSprite.menu:click()
		end,
		downButtonHold = function()
			-- Your code here
			self.playerSprite:stopPlayer()
		end,
		downButtonUp = function()
			-- Your code here
			self.playerSprite:goPlayer()
		end,
	
		-- Crank
		--
		cranked = function(change, acceleratedChange)	-- Runs when the crank is rotated. See Playdate SDK documentation for details.
			crankTick = crankTick + change
			if (crankTick > 60) then
				crankTick = 0
				if self.upgradeMenuSprite.menu.currentItemNumber < 3 then
					self.upgradeMenuSprite.menu:selectNext()
				end
			elseif (crankTick < -60) then
				crankTick = 0
				if self.upgradeMenuSprite.menu.currentItemNumber > 1 then
					self.upgradeMenuSprite.menu:selectPrevious()
				end
			end
		end,
		crankDocked = function()						-- Runs once when when crank is docked.
			-- Your code here
		end,
		crankUndocked = function()						-- Runs once when when crank is undocked.
			-- Your code here
		end
	}
end

function scene:enter()
	scene.super.enter(self)
	self.playerSprite:add(self.playerX,self.playerY)
	self.playerSprite:play()

	self.enemySpawnerSprite:add(-20, -20)
	self.enemySpawnerSprite:play()

	-- Upgrade Menu
	self.upgradeMenuSprite:add(-20, -20)
	self.upgradeMenuSprite:play()
end

function scene:start()
	scene.super.start(self)
end

function scene:update()
	scene.super.update(self)
	
	if self.drawPlayer then
		self.playerSprite:update()
	end

	if self.drawEnemySpawner then
		self.enemySpawnerSprite:updatePlayerSprite(self.playerSprite)
		self.enemySpawnerSprite:update()
	end

	self.ticks = self.ticks + 1
	if self.ticks > 120 then
		self.ticks = 0
	end
	
	self.scoreTracker:update()
	self:handleCollisions()

	-- Upgrade Menu
	self.upgradeMenuSprite:update()
end

function scene:handleCollisions()
	local collisions = NobleSprite.allOverlappingSprites()
	for i = 1, #collisions do
		local collisionPair = collisions[i]
		local firstSprite = collisionPair[1]
		local secondSprite = collisionPair[2]
		local ft = firstSprite.type
		local st = secondSprite.type
		if ((ft == "Enemy" and st == "Bullet") or (ft == "Bullet" and st == "Enemy")) then
			-- EnemySpawner and bullet are both destroyed.
			firstSprite.collided = true
			secondSprite.collided = true
			Noble.GameData.set(
				"Score",
				Noble.GameData.get("Score") + 1
			)
		elseif((ft == "Enemy" and st == "Player") or (ft == "Player" and st == "Enemy")) then
			-- Destroy the player
			self:destroyPlayer()
		elseif((ft == "Upgrade" and st == "Player") or (ft == "Player" and st == "Upgrade")) then
			-- Upgrade is collected (upgrade menu is opened and upgrade is removed)
			self:openUpgradeMenu()
			if ft == "Upgrade" then
				firstSprite.collected = true
			else
				secondSprite.collected = true
			end
		end
	end
end

function scene:openUpgradeMenu()
	self.upgradeMenuSprite:start()
	self.upgradeMenuSprite.active = true
	self.playerSprite.upgradeMenuOpened = true
	self.enemySpawnerSprite.upgradeMenuOpened = true
end

function scene:closeUpgradeMenu()
	self.upgradeMenuSprite:close()
	self.upgradeMenuSprite.active = false
	self.playerSprite.upgradeMenuOpened = false
	self.enemySpawnerSprite.upgradeMenuOpened = false
end

function scene:drawBackground()
	scene.super.drawBackground(self)
end

function scene:exit()
	scene.super.exit(self)
	self.upgradeMenuSprite:exit()
end

-- This runs once a transition to another scene completes.
function scene:finish()
	scene.super.finish(self)
	-- Your code here
end

function scene:pause()
	scene.super.pause(self)
	-- Your code here
end
function scene:resume()
	scene.super.resume(self)
	-- Your code here
end