FSM = Class:extend()

function FSM:new(state)
	self.state = state
end

function FSM:changeState(state)
	self.state = state
end

function FSM:update(dt)
	self[self.state](self, dt)
end

function FSM:draw()
	self[self.state .. "Draw"](self)
end

return FSM