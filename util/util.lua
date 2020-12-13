Util = {}

function Util.checkCollision(a, b)
	if a.x < b.x + b.width and
		a.x + a.width > b.x and
		a.y < b.y + b.height and
		a.y + a.height > b.y then
		return true
	end
	return false
end

function Util.isOffScreen(a)
	if a.y < - a.height * 2 or a.y > WINDOW_HEIGHT + a.height then
			return true
	end
	return false
end

function Util:updateObjectList(list, dt)
	for i, item in pairs(list) do
		item:update(dt)
		if self.isOffScreen(item) then
			table.remove(list, i)
		end
	end
end

function Util.drawObjectList(list)
	for i, item in pairs(list) do
		item:draw()
	end
end

return Util

