Background = Class:extend()

function Background:new(...)
	local arg = {...}
	if arg then
		self.imgs = arg
		self.img = arg[1]
		self.i = 1
		self.j = 1
	else
		self.img = gameBackgroundImg
	end
	self.scale = {
		x = WINDOW_WIDTH / self.img:getWidth(),
		y = WINDOW_HEIGHT / self.img:getHeight()
	}
	self.width = self.img:getWidth() * self.scale.x
	self.height = self.img:getHeight() * self.scale.y
    
	self.x = 0
	self.y = 0
	self.speed = 20
end

function Background:update(dt)
	self.y = (self.y + self.speed * dt) % self.height

	if self.imgs and self.y > self.height then
		if self.i >= #self.imgs then
			self.j = self.i
			self.i = 1
		else
			self.j = self.i
			self.i = self.i + 1
		end
		if self.j >= #self.imgs then
			self.j = 1
		end
	end
end

function Background:draw()
	love.graphics.draw(self.imgs[i] or self.img, self.x, self.y, 0, self.scale.x, self.scale.y)
	love.graphics.draw(self.imgs[j] or self.img, self.x, self.y - self.height, 0, self.scale.x, self.scale.y)
end