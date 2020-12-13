Animation = Class:extend()

function Animation:new(img, framesPerCol, framesPerLine, speed, quadIndexes)
	local quads = {}
	local quadWidth = img:getWidth() / framesPerCol
	local quadHeight = img:getHeight() / framesPerLine
	for y = 0, framesPerLine - 1 do
		for x = 0, framesPerCol - 1 do
			local quad = love.graphics.newQuad(x * quadWidth, y * quadHeight,
				quadWidth, quadHeight,
				img:getWidth(), img:getHeight())
			table.insert(quads, quad)
		end
	end
	self.img = img
	self.speed = speed or 20
	self.quads = {}
	if quadIndexes then
		self.quadAmount = #quadIndexes + 1
		for i, index in ipairs(quadIndexes) do
			table.insert(self.quads, quads[index])
		end
	else
		self.quadAmount = framesPerCol * framesPerLine
		for j = 0, framesPerLine - 1 do
			for i = 0, framesPerCol - 1 do
				table.insert(self.quads, quads[(i + j * framesPerCol) + 1])
			end
		end
	end
	self.currentQuad = 1
end

function Animation:update(dt)
	self.currentQuad = self.currentQuad + dt * self.speed
	if self.currentQuad > self.quadAmount then
		self.currentQuad = 1
	end
end

function Animation:draw(x, y, rotation, scaleX, scaleY)
	love.graphics.draw(
		self.img,
		self.quads[math.floor(self.currentQuad)],
		x, y, rotation, scaleX, scaleY)
end