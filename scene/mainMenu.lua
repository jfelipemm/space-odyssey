MainMenu = Class:extend()

function MainMenu:new()
	local bg = love.math.random(2, 5)
	background = Background(backgroundImgs[bg])

	self.delay = 1.5
	self.starting = false

	self.closingDelay = 1
	self.closing = false

	self.options = {
		{
			text = "START GAME"
		},
		{
			text = "QUIT"
		}
	}
	self.options.selected = 1
end

function MainMenu:update(dt)
	if self.starting then
		if self.delay >= 0 then
			self.delay = self.delay - dt
		else
			love.graphics.setColor(1, 1, 1)
			stages[1]:new()
			currentScene = "stage1"
		end
	elseif self.closing then
		background:update(dt)
		if self.closingDelay >= 0 then
			self.closingDelay = self.closingDelay - dt
		else
			love.event.quit()
		end
	else
		menuSoundtrack:setVolume(0.4)
		menuSoundtrack:play()
		background:update(dt)

		if love.keyboard.isDown("space") or love.keyboard.isDown("return") then
			self:chooseOption()
		else
			if love.keyboard.isDown("up") and self.options.selected > 1 then
				self.options.selected = self.options.selected - 1
			elseif love.keyboard.isDown("down") and self.options.selected < #self.options then
				self.options.selected = self.options.selected + 1
			end
		end
	end
end

function MainMenu:draw()
	love.graphics.setColor(1, 1, 1, self.delay)
	background:draw()

	love.graphics.setFont(fontTitleImg)
	love.graphics.print("SPACE",
		WINDOW_WIDTH / 4.4, WINDOW_HEIGHT / 6, 0, 2, 2)
	love.graphics.print("ODYSSEY",
		WINDOW_WIDTH / 7.9, WINDOW_HEIGHT / 3.7, 0, 2, 2)
	for i, item in ipairs(self.options) do
		if self.options.selected == i then
			love.graphics.setFont(fontTitleImg)
			love.graphics.print(item.text,
				WINDOW_WIDTH / 3.7, WINDOW_HEIGHT / (1.5 - 0.2 * (i - 1)), 0, 0.8, 0.8)
		else
			love.graphics.setFont(fontImg)
			love.graphics.print(item.text,
				WINDOW_WIDTH / 3.7, WINDOW_HEIGHT / (1.5 - 0.2 * (i - 1)), 0, 1.5, 1.5)
		end
	end

end

function MainMenu:chooseOption()
	if self.options.selected == 1 then
		menuSoundtrack:stop()
		soundShot1:play()
		self.starting = true
	elseif self.options.selected == 2 then
		menuSoundtrack:stop()
		soundShot1:play()
		self.closing = true
	end
end