GameOver = {}
class("GameOver").extends(NobleScene)
local scene = GameOver

function scene:setValues()
	self.color1 = Graphics.kColorBlack
	self.color2 = Graphics.kColorWhite

	self.backgroundColor = self.color1

	self.menu = nil
	self.sequence = nil

	self.menuX = 15

	self.menuYFrom = -50
	self.menuY = 15
	self.menuYTo = 240

	self.scoreDisplayX = 220
	self.scoreDisplayY = -20
	self.scoreDisplayW = 170
	self.scoreDisplayH = 130
	self.score = Noble.GameData.get("Score")
end

function scene:init()
	scene.super.init(self)

	-- self.logo = Graphics.image.new("libraries/noble/assets/images/NobleRobotLogo")

	self:setValues()

	self.menu = Noble.Menu.new(
		false,
		Noble.Text.ALIGN_LEFT,
		false,
		self.color2,
		4,6,0,
		Noble.Text.FONT_LARGE)

	self:setupMenu(self.menu)

	local crankTick = 0

	self.inputHandler = {
		upButtonDown = function()
			self.menu:selectPrevious()
		end,
		downButtonDown = function()
			self.menu:selectNext()
		end,
		cranked = function(change, acceleratedChange)
			crankTick = crankTick + change
			if (crankTick > 30) then
				crankTick = 0
				self.menu:selectNext()
			elseif (crankTick < -30) then
				crankTick = 0
				self.menu:selectPrevious()
			end
		end,
		AButtonDown = function()
			self.menu:click()
		end
	}
end

function scene:enter()
	scene.super.enter(self)
	self.sequence = Sequence.new():from(self.menuYFrom):to(self.menuY, 1.5, Ease.outBounce):start()
end

function scene:start()
	scene.super.start(self)

	self.menu:activate()
	self.menu:selectNext()
end

function scene:drawBackground()
	scene.super.drawBackground(self)
end

function scene:update()
	scene.super.update(self)

	Graphics.setColor(self.color1)
	Graphics.setDitherPattern(0.2, Graphics.image.kDitherTypeScreen)
	Graphics.fillRoundRect(self.menuX, self.sequence:get() or self.menuY, 185, 200, 15)
	self.menu:draw(self.menuX+15, self.sequence:get() + 8 or self.menuY+8)

	self:drawScores()

	Graphics.setColor(Graphics.kColorBlack)

end

function scene:exit()
	scene.super.exit(self)
	self.sequence = Sequence.new():from(self.menuY):to(self.menuYTo, 0.5, Ease.inSine)
	self.sequence:start();
end

function scene:setupMenu(__menu)
	-- __menu:addItem(Noble.Transition.Cut.name,						function() Noble.transition(GameOver2, nil, Noble.Transition.Cut) end)
	-- __menu:addItem(Noble.Transition.CrossDissolve.name,				function() Noble.transition(GameOver2, nil, Noble.Transition.CrossDissolve) end)
	__menu:addItem("Restart?",				function()
		Noble.transition(CombatOne, nil, Noble.Transition.DipToBlack)
		Noble.GameData.reset("Score")
	end)
	-- __menu:addItem(Noble.Transition.DipToWhite.name,				function() Noble.transition(GameOver2, nil, Noble.Transition.DipToWhite) end)
	-- __menu:addItem(Noble.Transition.Imagetable.name.." (Bolt)",		function() Noble.transition(GameOver2, nil, Noble.Transition.Imagetable) end)
	-- __menu:addItem(Noble.Transition.Imagetable.name.." (Curtain)",	function() Noble.transition(GameOver2, nil, Noble.Transition.Imagetable, {
	-- 	imagetable = Graphics.imagetable.new("libraries/noble/assets/images/ImagetableTransition"),
	-- 	rotateExit = true
	-- }) end)
	-- __menu:addItem(Noble.Transition.ImagetableMask.name,			function() Noble.transition(GameOver2, nil, Noble.Transition.ImagetableMask, {
	-- 	imagetable = Graphics.imagetable.new("libraries/noble/assets/images/ImagetableTransition")
	-- }) end)
	-- __menu:addItem(Noble.Transition.Spotlight.name,					function() Noble.transition(GameOver2, nil, Noble.Transition.Spotlight, {
	-- 	invert = true, xEnterStart = 50, yEnterStart = 50, xEnterEnd = 250, yEnterEnd = 200,
	-- }) end)
	-- __menu:addItem(Noble.Transition.SpotlightMask.name,				function() Noble.transition(GameOver2, nil, Noble.Transition.SpotlightMask, {
	-- 	invert = true
	-- }) end)
end

function scene:drawScores()
	Graphics.setColor(self.color2)
	Graphics.fillRoundRect(
		self.scoreDisplayX,
		self.scoreDisplayY,
		self.scoreDisplayW,
		self.scoreDisplayH,
		15)
	Graphics.setColor(self.color1)
	Noble.Text.draw(
        "Score: " .. self.score,
        self.scoreDisplayX + self.scoreDisplayW / 2,
		self.scoreDisplayY + self.scoreDisplayH / 3,
        Noble.Text.ALIGN_CENTER,
        false,
        Noble.Text.FONT_LARGE)
	Noble.Text.draw(
		"High Score: " .. Noble.GameData.get("HighScore"),
		self.scoreDisplayX + self.scoreDisplayW / 2,
		self.scoreDisplayY + self.scoreDisplayH * 2 / 3,
		Noble.Text.ALIGN_CENTER,
		false,
		Noble.Text.FONT_LARGE)
	-- self.logo:setInverted(true)
	-- self.logo:draw(275, 8)
end