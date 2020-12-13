file = Class:extend()

function file:new()
end

function file:save()
	local success, message = love.filesystem.write("saveDate.save", serpent.dump(data))
	if success then
		print("Save file successfully created/updated!")
	else
		print(message)
	end
end

function file:load()
	local exists = love.filesystem.getInfo("saveDate.save")
	if exists then
		local content, error = love.filesystem.read("saveDate.save")
		if content then
			exists, data = serpent.load(content)
		else
			print("Failure in reading save file!")
			print(error)
		end
	else
		file:save()
	end
end

return file