End = Class:extend()

function End:new()
	background = Background(backgroundImgs[5])

	player:resetPosition()
end

function End:update(dt)
	endSoundtrack:setVolume(0.4)
	endSoundtrack:play()

	player.animations.current = player.animations.idle
	player.animations.current:update(dt)

	background:update(dt)

	if love.keyboard.isDown("escape")
			or love.keyboard.isDown("return")
			or love.keyboard.isDown("space") then
		currentScene = "mainMenu"
		scenes[currentScene]:new()
		endSoundtrack:stop()
	end
end

function End:draw()
	player:draw()

	background:draw()
	local totalScore = 0
	for i = 1, #data do
		totalScore = totalScore + data[i].maxScore
	end

	love.graphics.print("Total Score: " .. totalScore, 240, 190)
	if totalScore < 800 then
		love.graphics.print("You can do better than this, I think.", 50, 220)
	elseif totalScore < 1600 then
		love.graphics.print("You did well. You deserve some praise", 50, 220)
	else
		love.graphics.print("I'm impressed by your skill.\nYou deserve the best prize!", 140, 220)
	end
end