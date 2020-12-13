Intro = Class:extend()

function Intro:new()
	self.y = WINDOW_HEIGHT
	self.speed = 40

	self.alpha = 0

	local bg = love.math.random(2, 5)
	background = Background(backgroundImgs[bg])

	introSoundtrack:setVolume(0.4)
	introSoundtrack:play()
end

function Intro:update(dt)
	self.y = self.y - self.speed * dt
	if self.y + 200 < 0 then
		currentScene = "mainMenu"
		introSoundtrack:stop()
	end
	
	if self.alpha < 1 then
		self.alpha = self.alpha + dt / 20
	end
	
	background:update(dt)
	
	if love.keyboard.isDown("escape") then
		currentScene = "mainMenu"
		introSoundtrack:stop()
	end
end

function Intro:draw()
	love.graphics.setColor(1, 1, 1, self.alpha)
	background:draw()
	love.graphics.setColor(1, 1, 1)
	love.graphics.print("A race to the center of the\n" ..
		"galaxy has begun. But speed\n" ..
		"is not the most important trait.\n" .. 
		"The best prize at the end is\n" .. 
		"only revealed to those worthy\n" .. 
		"of it. Do you think you have\n" .. 
		"what it takes?",
			60, self.y, 0, 1.2, 1.2)
end