require "util/fsm"

Stage = FSM:extend()

function Stage:new()
	self.super.super:new("start")
	self.state = "start"

	self.START_DELAY = 3
	self.PAUSE_DELAY = 0.2
	self.MENU_DELAY = 0.5
	self.COMPLETED_DELAY = 0.5
	self.TRANSITION_DELAY = 2.5

	self.startDelay = self.START_DELAY
	self.pauseDelay = self.PAUSE_DELAY
	self.menuDelay = self.MENU_DELAY
	self.completedDelay = self.COMPLETED_DELAY
	self.transitionDelay = self.TRANSITION_DELAY
	
	player = Player()

	self.playerCompletedSpeed = 400

	self.options = {
		{
			text = "RETRY"
		},
		{
			text = "MENU"
		}
	}
	self.options.selected = 1
	self.menu = false

	gameSoundtrack:setVolume(0.5)
end

function Stage:update(dt)
	self.super.super.update(self, dt)
end

function Stage:draw()
	self.super.super.draw(self)

	love.graphics.print("Life: ",
		WINDOW_WIDTH / 25, WINDOW_HEIGHT - WINDOW_HEIGHT / 15, 0,
		1, 1)
	for i = 1, player.life do
		love.graphics.draw(healthBarImg,
			WINDOW_WIDTH / 6 + (i - 1) * 12, WINDOW_HEIGHT - WINDOW_HEIGHT / 15, 0,
			1, 1)
	end
	love.graphics.print("Hi score: " .. data[self.stage.index].maxScore,
		WINDOW_WIDTH - WINDOW_WIDTH / 2.8, WINDOW_HEIGHT - WINDOW_HEIGHT / 10, 0,
		1, 1)
	love.graphics.print("Score: " .. player.score,
		WINDOW_WIDTH - WINDOW_WIDTH / 3.5, WINDOW_HEIGHT - WINDOW_HEIGHT / 15, 0,
		1, 1)
end

function Stage:pauseCheck(dt)
	if self.pauseDelay > 0 then
		self.pauseDelay = self.pauseDelay - dt
	end
	if love.keyboard.isDown("escape") and self.pauseDelay <= 0 then
		self:changeState("pause")
		self.pauseDelay = self.PAUSE_DELAY
	end
end

function Stage:endGame()
	if player.score > data[self.stage.index].maxScore then
		data[self.stage.index].maxScore = player.score
		fileUtil.save()
	end
	gameSoundtrack:stop()
	soundDeath:play()
	self:changeState("gameOver")
end

function Stage:start(dt)
	gameSoundtrack:play()
	background:update(dt)
	player:update(dt)

	if self.startDelay > 0 then
		self.startDelay = self.startDelay - dt
	end

	if self.startDelay <= 0 then
		self:changeState("game")
		self.startDelay = self.START_DELAY
	end
end

function Stage:gameOver(dt)
	background:update(dt)

	if (self.menuDelay > 0) then
		self.menuDelay = self.menuDelay - dt
	end

	if self.menu and self.menuDelay <= 0 then
		self.menu = false
		self:new()
		mainMenu:new()
		currentScene = "mainMenu"
	elseif not self.menu then
		if (love.keyboard.isDown("space") or love.keyboard.isDown("return")) and self.menuDelay <= 0 then
			if self.options.selected == 1 then
				self.menuDelay = self.MENU_DELAY
				self:new()
			elseif self.options.selected == 2 then
				soundShot1:play()
				self.menu = true
				self.menuDelay = self.MENU_DELAY
			end
		else
			if love.keyboard.isDown("up") and self.options.selected > 1 then
				self.options.selected = self.options.selected - 1
			elseif love.keyboard.isDown("down") and self.options.selected < #self.options then
				self.options.selected = self.options.selected + 1
			end
		end
	end
	
	self:updateObjects(dt)
	
	self.enemyDelay = self.enemyDelay - dt
	if self.enemyDelay <= 0 then
		local newEnemy = Enemy()
		table.insert(self.enemies, newEnemy)
		self.enemyDelay = self.ENEMY_DELAY
	end
end

function Stage:pause(dt)
	gameSoundtrack:pause()

	if self.pauseDelay > 0 then
		self.pauseDelay = self.pauseDelay - dt
	end

	if love.keyboard.isDown("escape") and self.pauseDelay <= 0 then
		gameSoundtrack:play()
		self:changeState("game")
		self.pauseDelay = self.PAUSE_DELAY
	end
end

function Stage:completed(dt)
	data[self.stage.index].stageCleared = true
	if player.score > data[self.stage.index].maxScore then
		data[self.stage.index].maxScore = player.score
	end
	fileUtil.save()
	if self.completedDelay > 0 then
		self.completedDelay = self.completedDelay - dt
	else
		player.animations.current = player.animations.idle
		player.y = player.y - self.playerCompletedSpeed * dt

		if self.transitionDelay > 0 then
			self.transitionDelay = self.transitionDelay - dt
		elseif self.stage.index >= #stages then
			currentScene = "end"
			gameSoundtrack:stop()
			scenes[currentScene]:new()
		else
			self.transitionDelay = self.TRANSITION_DELAY
			currentScene = "stage" .. (self.stage.index + 1)
			scenes[currentScene]:new()
		end
	end
end

function Stage:startDraw()
	self:gameDraw()

	love.graphics.setFont(fontTitleImg)
	love.graphics.print(self.stage.text,
		WINDOW_WIDTH / 2.8, WINDOW_HEIGHT / 2.2, 0, 0.8, 0.8)
	love.graphics.setFont(fontImg)

	if self.stage.index == 1 then
		love.graphics.print("Arrow keys to move",
			WINDOW_WIDTH / 3.5, WINDOW_HEIGHT / 1.3, 0, 1, 1)
		love.graphics.print("Space to shoot",
			WINDOW_WIDTH / 3, WINDOW_HEIGHT / 1.2, 0, 1, 1)
	end
end

function Stage:gameOverDraw()
	self:gameDraw()

	for i, item in ipairs(self.options) do
		if self.options.selected == i then
			love.graphics.setFont(fontTitleImg)
			love.graphics.print(item.text,
			WINDOW_WIDTH / 3, WINDOW_HEIGHT / (2.3 - 0.3 * (i - 1)), 0, 0.8, 0.8)
			love.graphics.setFont(fontImg)
		else
			love.graphics.setFont(fontImg)
			love.graphics.print(item.text,
				WINDOW_WIDTH / 3, WINDOW_HEIGHT / (2.3 - 0.3 * (i - 1)), 0, 1.5, 1.5)
		end
	end
end

function Stage:pauseDraw()
	self:gameDraw()

	love.graphics.setFont(fontTitleImg)
	love.graphics.print("PAUSED",
		WINDOW_WIDTH / 2.75, WINDOW_HEIGHT / 2.25, 0, 0.8, 0.8)
	love.graphics.setFont(fontImg)
end

function Stage:completedDraw()
	self:gameDraw()

	love.graphics.setFont(fontTitleImg)
	love.graphics.print(self.stage.text,
		WINDOW_WIDTH / 2.75, WINDOW_HEIGHT / 2.25, 0, 0.8, 0.8)
	love.graphics.print("FINISHED",
		WINDOW_WIDTH / 2.95, WINDOW_HEIGHT / 1.9, 0, 0.8, 0.8)
	love.graphics.setFont(fontImg)
end

return Stage
