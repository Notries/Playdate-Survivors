import 'Enemy'
import 'Upgrade'

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
    self.spawnRate = 100
    self.enemySpeedIncrease = 0
    self.enemies = {}
    self.enemyDeaths = 0
    self.upgradeThreshold = 5
    -- player variables
    self.playerSprite = {}
    -- collision
    self:setCollisionsEnabled(self.enemySpawnerX, self.enemySpawnerY, self.playerSizeX, self.playerSizeY)
    -- self:setCollisionsEnabled(false)
    -- upgrade menu variables
    self.upgradeMenuOpened = false
    -- upgrades
    self.upgrades = {}
end

function EnemySpawner:increaseUpgradeThreshold()
    self.enemyDeaths = 0
    self.upgradeThreshold = self.upgradeThreshold * 1.25
end

function EnemySpawner:init()
	EnemySpawner.super.init(self, "assets/images/EnemySpawner", true)
    self:setValues()
end

function EnemySpawner:updatePlayerSprite(playerSprite)
    self.playerSprite = playerSprite
end

function EnemySpawner:update()
    if not(self.upgradeMenuOpened or #self.enemies > 14) then
        -- advance the enemySpawner clock, and spawn an enemySpawner if it's time.
        self.tick = self.tick + 1
        if (self.tick > self.spawnRate) then
            self.tick = 0
            if (self.spawnRate > 1) then
                self.spawnRate = self.spawnRate - 0.5
            end
            local len = #self.enemies+1
            local enemyX = 0
            local enemyY = 0
            local health = 1
            if (self.spawnRate < 75 and self.spawnRate % 2 == 0) then
                health = 2
            end

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
            self.enemies[len] = Enemy(enemyX, enemyY, self.enemySpawnerX, self.enemySpawnerY, self.enemySpeedIncrease, health)
            self.enemies[len]:add(enemyX, enemyY)
            self.enemies[len]:play()

            self.enemySpeedIncrease = self.enemySpeedIncrease + 0.002
        end
    end

    -- iterate through all currently spawned enemies and update them
	for i = 1, #self.enemies do
		local enemy = self.enemies[i]
		if (enemy ~= nil) then
            if self.upgradeMenuOpened then
                enemy.upgradeMenuOpened = true
            else
                enemy.upgradeMenuOpened = false
            end

			if (enemy:isDead()) then
                self.enemyDeaths = self.enemyDeaths + 1
                if (self.enemyDeaths > self.upgradeThreshold) then
                    self:increaseUpgradeThreshold()
                    local upgradeLen = #self.upgrades + 1
                    self.upgrades[upgradeLen] = Upgrade(self.enemies[i].enemyX, self.enemies[i].enemyY)
                    self.upgrades[upgradeLen]:add(self.enemies[i].enemyX, self.enemies[i].enemyY)
                    self.upgrades[upgradeLen]:play()
                end
				table.remove(self.enemies, i)
				if i < #self.enemies then
					i = i - 1
				end
			else
                enemy:followPlayer(self.playerSprite)
				enemy:update()
			end
		end
	end

    -- iterate through all upgrades and draw them
    for i = 1, #self.upgrades do
        local upgrade = self.upgrades[i]
        if (upgrade ~= nil) then
            if (upgrade.collected) then
                table.remove(self.upgrades, i)
                if i < #self.upgrades then
                    i = i - 1
                end
            else
                upgrade:update()
            end
        end
    end
end