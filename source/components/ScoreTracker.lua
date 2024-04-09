-- SCORE TRACKER
-- Handles the updating of the high score
-- Score tracking is actually mostly handled by the scene (CombatOne.lua), but a lot of that should probably be moved in here.
-- Updated by scene

ScoreTracker = {}
class("ScoreTracker").extends(NobleSprite)

function ScoreTracker:setValues()
    -- identifier
	self.type = 'ScoreTracker'
    --- score tracker variables
    self.score = Noble.GameData.get("Score")
    self.font = Noble.Text.FONT_LARGE
    self.alignment = Noble.Text.ALIGN_RIGHT
    self.scoreTrackerX = 399
    self.scoreTrackerY = 1
end

function ScoreTracker:init()
	ScoreTracker.super.init(self, "assets/images/scoreTracker", true)
    self:setValues()
end

function ScoreTracker:update()
    self.score = Noble.GameData.get("Score")
    self.highScore = Noble.GameData.get("HighScore")
    if self.score > self.highScore then
        Noble.GameData.set("HighScore", self.score)
        Noble.GameData.save()
    end
    Noble.Text.draw(
        self.score,
        self.scoreTrackerX,
        self.scoreTrackerY,
        self.alignment,
        false,
        self.font)
end