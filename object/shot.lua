Shot = Class:extend()

function Shot:new(x, y)
	self.FRAMES_PER_LINE = 2
	self.FRAMES_PER_COL = 2
	self.ANIMATION_SPEED = 5
	self.IMG_SCALE = 1.5
	
	self.img = laserBoltsImg
	self.quad = self:loadQuad()
	self.sound = soundShot1:clone()
	self.sound:setVolume(0.4)
	self.width = self.quadWidth * self.IMG_SCALE / 2
	self.height = self.quadHeight * self.IMG_SCALE

	self.xImg = x + 7
	self.x = x + 13
	self.y = y
	self.speed = 500
end

function Shot:update(dt)
	self.y = self.y - self.speed * dt
end

function Shot:draw()
	love.graphics.draw(self.img, self.quad, self.xImg, self.y, 0, self.IMG_SCALE, self.IMG_SCALE)
	if showHitbox then
		love.graphics.setColor(1, 0, 0)
		love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
		love.graphics.setColor(1, 1, 1)
	end
end

function Shot:loadQuad()
	self.quadWidth = self.img:getWidth() / self.FRAMES_PER_LINE
	self.quadHeight = self.img:getHeight() / self.FRAMES_PER_COL
	return love.graphics.newQuad(0 * self.quadWidth, 1 * self.quadHeight,
		self.quadWidth, self.quadHeight,
		self.img:getWidth(), self.img:getHeight())
end