local StateMachine = {}
StateMachine.__index = StateMachine

function StateMachine.new()
	local self = setmetatable({}, StateMachine)
	self.states = {}
	self.order = {}
	self.current = nil
	self.previous = nil
	self.locked = false
	return self
end

function StateMachine:add(name, anim, opts)
	opts = opts or {}
	self.states[name] = {
		anim = anim,
		interrupt = opts.interrupt ~= false,
		onEnter = opts.onEnter,
		onExit = opts.onExit,
	}
	self.order[#self.order + 1] = name
	return self
end

function StateMachine:has(name)
	return self.states[name] ~= nil
end

function StateMachine:is(name)
	return self.current == name
end

function StateMachine:transition(name)
	if name == self.current then
		return false
	end
	local nextState = self.states[name]
	if not nextState then
		return false
	end
	local currentState = self.current and self.states[self.current]
	if currentState and not currentState.interrupt and currentState.anim
		and not currentState.anim.finished then
		return false
	end

	if currentState and currentState.onExit then
		currentState.onExit(self.states[self.current].anim)
	end

	self.previous = self.current
	self.current = name
	nextState.anim:reset()
	if nextState.onEnter then
		nextState.onEnter(nextState.anim)
	end
	return true
end

function StateMachine:update(dt)
	local state = self.current and self.states[self.current]
	if state then
		state.anim:update(dt)
	end
end

function StateMachine:draw(x, y, facing, originX, originY)
	local state = self.current and self.states[self.current]
	if state then
		state.anim:draw(x, y, facing, originX, originY)
	end
end

function StateMachine:animation()
	local state = self.current and self.states[self.current]
	return state and state.anim
end

function StateMachine:currentRect()
	local state = self.current and self.states[self.current]
	return state and state.anim:current()
end

return StateMachine
