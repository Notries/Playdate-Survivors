-- STRONG ENEMEY
-- Extended from Enemy, just changes the spritesheet.
-- Handles the physics and animation of strong enemies.
-- Updated by EnemySpawner.lua

StrongEnemy = {}
class("StrongEnemy").extends("Enemy")

function StrongEnemy:init(__x, __y, __enemySpawnerX, __enemySpawnerY, __enemySpeedIncrease, __health)
	StrongEnemy.super.super.init(self, "assets/images/strong-enemy", true)
    self:setValues(__x, __y, __enemySpawnerX, __enemySpawnerY, __enemySpeedIncrease, __health)
end