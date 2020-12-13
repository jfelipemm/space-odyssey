require "scene/stage"
util = require("util/util")

Stage1 = Stage:extend()

function Stage1:new()
	self.super:new()
	self.state = "start"
	
	self.ENEMY_DELAY = 2

	self.stage = {
		index = 1,
		text = "STAGE 1"
	}

	self.enemyDelay = 0

	background = Background(backgroundImgs[2])

	self.enemies = {}
	self.enemiesAmount = 40

	self.shots = {}
	self.shotDelay = player.shotDelay
	self.enemyShots = {}
end

function Stage1:update(dt)
	self.super.update(self, dt)
end

function Stage1:draw()
	self.super.draw(self)
end

function Stage1:game(dt)
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

	self:updateObjects(dt)

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

	if self.enemiesAmount <= 0 and #self.enemies <= 0 then
		self:changeState("completed")
	end
end

function Stage1:gameDraw()
	background:draw()
	self:drawObjects()
	if self.state ~= "gameOver" then
		player:draw()
	end
end

function Stage1:updateObjects(dt)
	util:updateObjectList(self.shots, dt)
	util:updateObjectList(self.enemyShots, dt)
	util:updateObjectList(self.enemies, dt)
end

function Stage1:drawObjects()
	util.drawObjectList(self.enemies)
	util.drawObjectList(self.shots)
	util.drawObjectList(self.enemyShots)
end