Meteor = Class:extend()

function Meteor:new(speed, points, scale, life)
	self.DEFAULT_SCALE = 1
	self.DEFAULT_SPEED = 200

	self.img = meteorImg1
	self.speed = speed or self.DEFAULT_SPEED
	self.points = points or 10
	self.scale = scale or self.DEFAULT_SCALE
	self.life = life or 1

	self.sound = soundCrash:clone()
	self.sound:setVolume(0.3)

	self.width = self.img:getWidth() * self.scale
	self.height = self.img:getHeight() * self.scale
	
	self.x = x or love.math.random(50, WINDOW_WIDTH - self.width - 50)
	self.y = - self.height
end

function Meteor:update(dt)
	self.y = self.y + self.speed * dt
end

function Meteor:draw()
	love.graphics.draw(self.img, self.x, self.y, 0, self.scale, self.scale)
	if showHitbox then
		love.graphics.setColor(1, 0, 0)
		love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
		love.graphics.setColor(1, 1, 1)
	end
end