require "util/fsm"
Enemy = FSM:extend()

function Enemy:new(life)
	self.START_DELAY = 0.5
	self.SHOT_DELAY = 0.3 * love.math.random(1, 2)

	self.startDelay = self.START_DELAY
	self.shotDelay = self.SHOT_DELAY

	local number = love.math.random(1, 3)
	self.img = enemyImgs[number]

	self.scale = 1.5

	self.width = self.img:getWidth()* self.scale
	self.height = self.img:getHeight() * self.scale

	self.x = love.math.random(50, WINDOW_WIDTH - self.width - 50)
	number = love.math.random(1, 4)
	local vel = love.math.random(1, 2)
	if number == 1 then
		self.y = -self.height - 10
		self.velY = 100 * vel
	else
		self.y = WINDOW_HEIGHT + 10
		self.velY = -100 * vel
	end
	self.aggroVelY = self.velY / 1.5
	self.speed = 150
	self.velX = 0

	self.shooting = false

	self.life = life or 1

	self.points = self.life * 10

	self.sound = soundCrash:clone()
	self.sound:setVolume(0.3)

	self.super:new("idle")
end

function Enemy:update(dt)
	self.super.update(self, dt)
end

function Enemy:draw()
	love.graphics.draw(self.img, self.x, self.y, 0, self.scale, self.scale)
	if showHitbox then
		love.graphics.setColor(1, 0, 0)
		love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
		love.graphics.setColor(1, 1, 1)
	end
end

function Enemy:move(dt)
	self.x = self.x + self.velX * dt
	self.y = self.y + self.velY * dt
end

function Enemy:idle(dt)
	self:move(dt)

	if self.startDelay > 0 then
		self.startDelay = self.startDelay - dt
	else
		local number = love.math.random(1, 4)
		if number == 1 then
			self:changeState("passive")
		else
			self:changeState("aggro")
		end
	end
end

function Enemy:passive(dt)
	self:move(dt)
end

function Enemy:aggro(dt)
	if self.shotDelay > 0 then
		self.shotDelay = self.shotDelay - dt
	end
	if self.y > player.y + player.height then
		self.shooting = true
		self.velY = self.aggroVelY
		self.velX = self.speed * (player.x - self.x) / math.abs(player.x - self.x)
	end
	self:move(dt)
end