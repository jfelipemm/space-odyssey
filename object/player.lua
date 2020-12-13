Player = Class:extend()

function Player:new()
	require "util/animation"

	self.FRAMES_PER_LINE = 5
	self.FRAMES_PER_COL = 2
	self.ANIMATION_SPEED = 20
	self.IMG_SCALE = 2.5

	self.animations = {}
	self.animations.idle = Animation(playerShipImg, 5, 2, 20, {3, 8})
	self.animations.left = Animation(playerShipImg, 5, 2, 20, {2, 7})
	self.animations.right = Animation(playerShipImg, 5, 2, 20, {4, 9})
	self.animations.current = self.animations.idle
	
	self.width = (playerShipImg:getWidth() / 5) * self.IMG_SCALE
	self.height = (playerShipImg:getHeight() / 2) * self.IMG_SCALE
		- (playerShipImg:getHeight() / 2) * self.IMG_SCALE / 3
	
	self:resetPosition()
	self.fixedSpeed = 250

	self.shotDelay = 0.65

	self.canMove = true

	self.life = 5
	self.score = 0
end

function Player:update(dt)
	self.animations.current = self.animations.idle

	if currentScene ~= "mainMenu" then
		if self.canMove then
			self:checkMovement(dt)
		end
	end
	
	self:keepInScreen()
	self.animations.current:update(dt)
end

function Player:draw()
	self.animations.current:draw(self.x, self.y, 0, self.IMG_SCALE, self.IMG_SCALE)

	if showHitbox then
		love.graphics.setColor(1, 0, 0)
		love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
		love.graphics.setColor(1, 1, 1)
	end
end

function Player:keepInScreen()
	if self.x < 0 then
		self.x = 0
	elseif self.x + self.width > WINDOW_WIDTH then
		self.x = WINDOW_WIDTH - self.width
	end
	
	if self.y < 0 then
		self.y = 0
	elseif self.y + self.height > WINDOW_HEIGHT then
		self.y = WINDOW_HEIGHT - self.height
	end
end

function Player:checkCollision(o)
	if self.x < o.x + o.width and
	self.x + self.width > o.x and
	self.y < o.y + o.height and
	self.y + self.height > o.y then
		return true
	end
	return false
end

function Player:checkMovement(dt)
	local speed = self.fixedSpeed

	if love.keyboard.isDown("left") then
		self.x = self.x - speed * dt
		self.animations.current = self.animations.left
	end
	if love.keyboard.isDown("up") then
		self.y = self.y - speed * dt
	end
	if love.keyboard.isDown("right") then
		self.x = self.x + speed * dt
		self.animations.current = self.animations.right
	end
	if love.keyboard.isDown("down") then
		self.y = self.y + speed * dt
	end
end

function Player:resetPosition()
	self.x, self.y = WINDOW_WIDTH / 2 - playerShipImg:getWidth() / 2, WINDOW_HEIGHT -  WINDOW_HEIGHT / 4
end