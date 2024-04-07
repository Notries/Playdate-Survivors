DirectionIndicator = {}
class("DirectionIndicator").extends(NobleSprite)

function DirectionIndicator:setValues()
    -- identifier
	self.type = 'DirectionIndicator'
    -- direction indicator animation
    self.animation:addState("directionIndicator", 1, 1)
	self.animation:setState("directionIndicator")
    --- direction indicator variables
    self.directionIndicatorX = 0
    self.directionIndicatorY = 0
    -- collision (or lack thereof)
    self:setCollisionsEnabled(false)
end

function DirectionIndicator:init()
	DirectionIndicator.super.init(self, "assets/images/directionIndicator", true)
    self:setValues()
end

function DirectionIndicator:updatePosition(__x, __y)
    -- called by Player, which holds the input handler.
    self.directionIndicatorX = __x
    self.directionIndicatorY = __y
end

function DirectionIndicator:update()
    self:draw(self.directionIndicatorX, self.directionIndicatorY, false) 
end