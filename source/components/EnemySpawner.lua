import 'Enemy'

EnemySpawner = {}
class("EnemySpawner").extends(NobleSprite)

function EnemySpawner:setValues()
    -- identifier
	self.type = 'EnemySpawner'
    -- enemySpawner animation
    self.animation:addState("walk", 1, 3, nil, nil, nil, 2)
	self.animation:setState("walk")
    --- enemySpawner variables
    self.tick = 0
    self.enemySpawnerSizeX = 16
    self.enemySpawnerSizeY = 32
    self.enemySpawnerX = -20
    self.enemySpawnerY = -20
    self.enemySpawnerVelocity = 1
    self.enemySpawnerVelocityX = 0
    self.enemySpawnerVelocityY = 5
    -- enemy variables
    --- spawnRate: lower is faster
    self.spawnRate = 120
    self.enemies = {}
    -- player variables
    self.playerSprite = {}
    -- collision
    self:setCollisionsEnabled(self.enemySpawnerX, self.enemySpawnerY, self.playerSizeX, self.playerSizeY)
    -- self:setCollisionsEnabled(false)
end

function EnemySpawner:init()
	EnemySpawner.super.init(self, "assets/images/EnemySpawner", true)
    self:setValues()
end

function EnemySpawner:updatePlayerSprite(playerSprite)
    self.playerSprite = playerSprite
end

function EnemySpawner:update()
    -- advance the enemySpawner clock, and spawn an enemySpawner if it's time.
    self.tick = self.tick + 1
    if (self.tick > self.spawnRate) then
        self.tick = 0
		local len = #self.enemies+1
        local enemyX = 0
        local enemyY = 0

        -- Determine which side of the screen the enemy will come from
        math.randomseed(playdate.getSecondsSinceEpoch())
        local side = math.random(4)
        -- Then determine which position they'll spawn at on the given side
        math.randomseed(playdate.getSecondsSinceEpoch() + 5)
        if (side == 1 or side == 3) then
            enemyX = math.random(400)
            if (side == 1) then
                enemyY = 0 - Enemy.getEnemySizeY()
            else
                enemyY = 240
            end
        else
            enemyY = math.random(240)
            if (side == 2) then
                enemyX = 400
            else
                enemyX = 0 - Enemy.getEnemySizeX()
            end
        end
        self.enemies[len] = Enemy(enemyX, enemyY, self.enemySpawnerX, self.enemySpawnerY)
		self.enemies[len]:add(enemyX, enemyY)
		self.enemies[len]:play()
    end

    -- iterate through all currently spawned enemies and update them
	for i = 1, #self.enemies do
		local enemy = self.enemies[i]
		if (enemy ~= nil) then
			if (enemy:isDead()) then
				table.remove(self.enemies, i)
				if i < #self.enemies then
					i = i - 1
				end
			else
                enemy:followPlayer(self.playerSprite)
				enemy:update()
			end
		else
			table.remove(self.enemies, i)
			if i < #self.enemies then
				i = i - 1
			end
		end
	end
end