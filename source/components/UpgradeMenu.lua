UpgradeMenu = {}
class("UpgradeMenu").extends(NobleSprite)

function UpgradeMenu:setValues(scene)
    -- identifier
	self.type = 'UpgradeMenu'
    -- upgradeMenu animation
    self.animation:addState("upgradeMenu", 1, 1)
	self.animation:setState("upgradeMenu")
    --- upgradeMenu variables
    self.menu = nil
    self.sequence = nil

	self.menuX = 15
    self.menuWidth = 225

	self.menuYFrom = -50
	self.menuY = 15
	self.menuYTo = 240
    self.menuPaddingTop = 58
    self.menuHeight = 200

    -- description display
    self.descriptionX = 250
    self.descriptionWidth = 135

    self.active = false

    -- colors
    self.color1 = Graphics.kColorBlack
	self.color2 = Graphics.kColorWhite

    -- scene variables
    self.scene = scene

    -- upgrade table
    --- NOTE: descriptions can fit ~14 characters on one line
    --- NOTE: avoid settings disabled to true-- it causes significant slowdown when collecting upgrades. Instead, just remove the entry from the table.
    self.upgradeTable = {
        {
            title = "In-fig-orate!",
            description = "Increase your\nmovement\nspeed.",
            effect = function() 
                self.scene.playerSprite.playerVelocity = self.scene.playerSprite.playerVelocity * 1.5
                self.scene:closeUpgradeMenu()
            end,
            disabled = false
        },
        {
            title = "Durian Fury",
            description = "Increase the\nfire rate of\nall of your\nweapons.",
            effect = function()
                self.scene.playerSprite.fireRate = self.scene.playerSprite.fireRate * 0.8
                self.scene:closeUpgradeMenu()
            end,
            disabled = false
        },
        {
            title = "Watermelon Mellow",
            description = "Decrease the\nmovement\nspeed of your\nbullets.",
            effect = function()
                self.scene.playerSprite.bulletSpeedModifier = self.scene.playerSprite.bulletSpeedModifier * 0.35
                self.scene:closeUpgradeMenu()
            end,
            disabled = false
        },
        {
            title = "Cherry Bomb",
            description = "Fires two\ncherries that\nfall to either\nside.",
            effect = function()
                self.scene.playerSprite.cherryBombEnabled = true
                table.remove(self.upgradeTable, 4)
                self.scene:closeUpgradeMenu()
            end,
            disabled = false
        }
    }
    self.map = {}
end

function UpgradeMenu:init(scene)
	UpgradeMenu.super.init(self, "assets/images/directionIndicator", true)
    self:setValues(scene)

    self.menu = Noble.Menu.new(
		false,
		Noble.Text.ALIGN_LEFT,
		false,
		self.color2,
		4,6,(self.menuHeight - self.menuPaddingTop) / 6,
		Noble.Text.FONT_MEDIUM)
end

function UpgradeMenu:setupMenu(__menu)
    self.map = {}
    local index = 0
    local tick = 0
    
    for j = 1, 3 do
        local searching = true
        local foundTheSame = false
        math.randomseed(playdate.getSecondsSinceEpoch() + tick)
        index = math.random(#self.upgradeTable)
        while searching do
            if self.upgradeTable[index].disabled then
                math.randomseed(playdate.getSecondsSinceEpoch() + tick)
                index = math.random(#self.upgradeTable)
                foundTheSame = true
            end
            for i = 1, #self.map do
                if foundTheSame then
                    break
                end
                local indexAlreadySelected = self.map[i]
                if (indexAlreadySelected ~= nil) then
                    if index == indexAlreadySelected then
                        tick = tick + 1
                        math.randomseed(playdate.getSecondsSinceEpoch() + tick)
                        index = math.random(#self.upgradeTable)
                        foundTheSame = true
                        break
                    end
                end
            end
            if not(foundTheSame) then
                searching = false
            else
                foundTheSame = false
            end
        end
        self.map[#self.map+1] = index
        __menu:addItem(
            self.upgradeTable[index].title,
            self.upgradeTable[index].effect)
    end
end

function UpgradeMenu:update()
    -- MENU
    if (self.active and self.sequence ~= nil) then
        Graphics.setColor(Graphics.kColorBlack)
        Graphics.fillRoundRect(
            self.menuX,
            self.sequence:get() or self.menuY,
            self.menuWidth,
            self.menuHeight,
            15)
        Graphics.fillRoundRect(
            self.descriptionX,
            self.sequence:get() or self.menuY,
            self.descriptionWidth,
            self.menuHeight,
            15)
        Graphics.setColor(Graphics.kColorWhite)
        Graphics.setImageDrawMode(Graphics.kDrawModeFillWhite)
        Noble.Text.draw(
            "Pick an upgrade!",
            self.menuX+15,
            self.sequence:get()+20 or self.menuY+20,
            Noble.Text.ALIGN_LEFT,
            false,
            Noble.Text.FONT_LARGE)
        if self.menu.currentItemNumber > 0 and self.menu.currentItemNumber <= 3 then
            Noble.Text.draw(
                self.upgradeTable[self.map[self.menu.currentItemNumber]].description,
                self.descriptionX+15,
                self.sequence:get()+20 or self.menuY+20,
                Noble.Text.ALIGN_LEFT,
                false,
                Noble.Text.FONT_MEDIUM
            ) 
        end
        Graphics.setImageDrawMode(Graphics.kDrawModeCopy)
        self.menu:draw(self.menuX+15, self.sequence:get() + self.menuPaddingTop or self.menuY+self.menuPaddingTop)
    elseif (self.active) then
        self:setupMenu(self.menu)
        self:start()
        self.sequence = Sequence.new():from(self.menuYFrom):to(self.menuY, 1.5, Ease.outBounce):start()
    end
end

function UpgradeMenu:start()
    self.menu:activate()
	self.menu:selectNext()
end

function UpgradeMenu:close()
    self.menu:removeItem()
    self.menu:removeItem()
    self.menu:removeItem()
    self.menu:deactivate()
    self.sequence = nil
end

function UpgradeMenu:exit()
    self.menu:deactivate()
    self.sequence = nil
end