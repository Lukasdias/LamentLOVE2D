local Animation = {}
Animation.__index = Animation

function Animation.new(sheet, frames, fps, opts)
	opts = opts or {}
	local self = setmetatable({}, Animation)
	self.sheet = sheet
	self.frames = frames
	self.fps = fps or 0.1
	self.loop = opts.loop ~= false
	self.onEnd = opts.onEnd
	self.index = 1
	self.timer = 0
	self.finished = false
	return self
end

function Animation:reset()
	self.index = 1
	self.timer = 0
	self.finished = false
end

function Animation:gotoFrame(i)
	self.index = math.max(1, math.min(#self.frames, i))
	self.timer = 0
end

function Animation:update(dt)
	if self.finished or #self.frames == 0 then
		return
	end
	self.timer = self.timer + dt
	while self.timer >= self.fps do
		self.timer = self.timer - self.fps
		self.index = self.index + 1
		if self.index > #self.frames then
			if self.loop then
				self.index = 1
			else
				self.index = #self.frames
				self.finished = true
				if self.onEnd then
					self.onEnd(self)
				end
				return
			end
		end
	end
end

function Animation:current()
	return self.frames[self.index]
end

function Animation:draw(x, y, facing, originX, originY)
	local rect = self:current()
	if not rect then
		return
	end
	love.graphics.draw(
		self.sheet.image,
		self.sheet:quad(rect),
		x, y,
		0,
		facing or 1, 1,
		originX or rect.w / 2,
		originY or rect.h
	)
end

return Animation
