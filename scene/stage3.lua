require "scene/stage"
util = require("util/util")

Stage3 = Stage:extend()

function Stage3:new()
	self.super:new()
	self.state = "start"

	self.ENEMY_DELAY = 5
	self.METEOR_DELAY = 2
	self.METEOR2_DELAY = 20

	self.stage = {
		index = 3,
		text = "STAGE 3"
	}

	self.enemyDelay = 0
	self.meteorDelay = self.METEOR_DELAY
	self.meteor2Delay = self.METEOR2_DELAY

	background = Background(backgroundImgs[4])

	self.enemies = {}
	self.enemiesAmount = 20

	self.meteors = {}
	self.meteors1Amount = 50
	self.meteors2Amount = 5

	self.shots = {}
	self.shotDelay = player.shotDelay
	self.enemyShots = {}
end

function Stage3:update(dt)
	self.super.update(self, dt)
end

function Stage3:draw()
	self.super.draw(self)
end

function Stage3:game(dt)
	gameSoundtrack:play()
	background:update(dt)
	player:update(dt)

	self:pauseCheck(dt)
	
	if self.shotDelay > 0 then
		self.shotDelay = self.shotDelay - dt
	end
	if love.keyboard.isDown("space") then
		if self.shotDelay <= 0 then
			local newShot = Shot(player.x, player.y)
			table.insert(self.shots, newShot)
			self.shotDelay = player.shotDelay
			newShot.sound:play()
		end
	end

	self.enemyDelay = self.enemyDelay - dt
	if self.enemyDelay <= 0 and self.enemiesAmount > 0 then
		local newEnemy = Enemy()
		table.insert(self.enemies, newEnemy)
		self.enemiesAmount = self.enemiesAmount - 1
		self.enemyDelay = self.ENEMY_DELAY
	end
	
	self.meteorDelay = self.meteorDelay - dt
	self.meteor2Delay = self.meteor2Delay - dt
	if self.meteorDelay <= 0 and self.meteors1Amount > 0 then
		local newMeteor = Meteor(150, 10)
		table.insert(self.meteors, newMeteor)
		self.meteors1Amount = self.meteors1Amount - 1
		self.meteorDelay = self.METEOR_DELAY
	end
	if self.meteor2Delay <= 0 and self.meteors2Amount > 0 then
		local newMeteor = Meteor(80, 50, 3, 3)
		table.insert(self.meteors, newMeteor)
		self.meteors2Amount = self.meteors2Amount - 1
		self.meteorDelay = self.METEOR_DELAY
		self.meteor2Delay = self.METEOR2_DELAY
	end

	self:updateObjects(dt)

	for i, meteor in pairs(self.meteors) do
		if util.checkCollision(player, meteor) then
			self:endGame()
		end
		for j, shot in pairs(self.shots) do
			if util.checkCollision(shot, meteor) then
				meteor.life = meteor.life - 1
				table.remove(self.shots, j)
				if meteor.life <= 0 then
					table.remove(self.meteors, i)
					meteor.sound:play()
					player.score = player.score + meteor.points
				end
			end
		end
	end

	for i, enemy in pairs(self.enemies) do
		if util.checkCollision(player, enemy) then
			self:endGame()
		end
		for j, shot in pairs(self.shots) do
			if util.checkCollision(shot, enemy) then
				enemy.life = enemy.life - 1
				table.remove(self.shots, j)
				if enemy.life <= 0 then
					table.remove(self.enemies, i)
					enemy.sound:play()
					player.score = player.score + enemy.points
				end
			end
		end
		if enemy.shooting and enemy.shotDelay <= 0 then
			local newShot = EnemyShot(enemy.x, enemy.y)
			table.insert(self.enemyShots, newShot)
			newShot.sound:play()
			enemy.shotDelay = enemy.SHOT_DELAY
		end
	end

	for i, shot in pairs(self.enemyShots) do
		if util.checkCollision(shot, player) then
			player.life = player.life - 1
			table.remove(self.enemyShots, i)
			soundHit:clone():play()
			if player.life <= 0 then
				self:endGame()
			end
		end
	end

	if self.enemiesAmount <= 0
			and #self.enemies <= 0
			and self.meteors1Amount <= 0
			and self.meteors2Amount <= 0
			and #self.meteors <= 0 then
		self:changeState("completed")
	end
end

function Stage3:gameDraw()
	background:draw()
	self:drawObjects()
	if self.state ~= "gameOver" then
		player:draw()
	end
end

function Stage3:updateObjects(dt)
	util:updateObjectList(self.shots, dt)
	util:updateObjectList(self.enemyShots, dt)
	util:updateObjectList(self.enemies, dt)
	util:updateObjectList(self.meteors, dt)
end

function Stage3:drawObjects()
	util.drawObjectList(self.meteors)
	util.drawObjectList(self.enemies)
	util.drawObjectList(self.shots)
	util.drawObjectList(self.enemyShots)
end