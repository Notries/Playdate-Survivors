import '../CoreLibs/crank'
import '../components/Player'
import '../components/EnemySpawner'

BasicScene = {}
class("BasicScene").extends(NobleScene)
local scene = BasicScene
scene.backgroundColor = Graphics.kColorWhite

function scene:destroyEnemySpawner()
	self.drawEnemySpawner = false
end

function scene:destroyPlayer()
	self.drawPlayer = false
	self.playerSprite:remove()
end

function scene:setValues()
	-- Directory starts in /source
	self.playerSprite = Player()
	self.enemySpawnerSprite = EnemySpawner()
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
			if (crankTick > 30) then
				crankTick = 0
			elseif (crankTick < -30) then
				crankTick = 0
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
end

function scene:start()
	scene.super.start(self)
end

function scene:update()
	scene.super.update(self)
	-- self:destroyEnemySpawner()
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
		print("PLAYER")
		printTable(self.playerSprite:getCollideBounds())
		printTable(self.playerSprite:getPosition())
		print("ENEMY SPAWNER SPRITE")
		printTable(self.enemySpawnerSprite:getCollideBounds())
		printTable(self.enemySpawnerSprite:getPosition())
		print("ALL ENEMIES")
		for i = 1, #self.enemySpawnerSprite.enemies do
			printTable(self.enemySpawnerSprite.enemies[i]:getCollideBounds())
			printTable(self.enemySpawnerSprite.enemies[i]:getPosition())
		end
	end
	
	self:handleCollisions()
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
		elseif((ft == "Enemy" and st == "Player") or (ft == "Player" and st == "Enemy")) then
			-- Destroy the player
			-- TODO trigger a game over
			self:destroyPlayer()
		end
	end
end

function scene:drawBackground()
	scene.super.drawBackground(self)
end

function scene:exit()
	scene.super.exit(self)
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