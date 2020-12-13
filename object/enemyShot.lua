EnemyShot = Class:extend()

function EnemyShot:new(x, y)
	self.scale = 1.5
	
	self.img = enemyShotImgs[1]
	self.sound = soundShot2:clone()
	self.sound:setVolume(0.7)
	self.width = self.img:getWidth() * self.scale / 2
	self.height = self.img:getHeight() * self.scale

	self.x = x + 25
	self.y = y
	self.speed = 500
end

function EnemyShot:update(dt)
	self.y = self.y - self.speed * dt
end

function EnemyShot:draw()
	love.graphics.draw(self.img, self.x, self.y, 0, self.scale, self.scale)
	if showHitbox then
		love.graphics.setColor(1, 0, 0)
		love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
		love.graphics.setColor(1, 1, 1)
	end
end