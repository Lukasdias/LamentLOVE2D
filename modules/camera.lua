local Camera = {}
Camera.__index = Camera

local function clamp(v, lo, hi)
	if lo > hi then
		return (lo + hi) / 2
	end
	if v < lo then
		return lo
	elseif v > hi then
		return hi
	end
	return v
end

function Camera.new(opts)
	opts = opts or {}
	local self = setmetatable({}, Camera)
	self.scale = opts.scale or 1
	self.lerp = opts.lerp or 8
	self.deadzone = opts.deadzone or 0
	self.clampEnabled = opts.clamp ~= false
	self.x, self.y = 0, 0
	self.tx, self.ty = 0, 0
	self.bounds = nil
	return self
end

function Camera:setBounds(x, y, w, h)
	self.bounds = { x = x, y = y, w = w, h = h }
	self:applyBounds()
	return self
end

function Camera:follow(x, y)
	self.tx, self.ty = x, y
end

function Camera:snap(x, y)
	self.tx, self.ty = x, y
	self.x, self.y = x, y
	self:applyBounds()
end

function Camera:applyBounds()
	if not (self.bounds and self.clampEnabled) then
		return
	end
	local halfW = love.graphics.getWidth() / (2 * self.scale)
	local halfH = love.graphics.getHeight() / (2 * self.scale)
	local b = self.bounds
	self.x = clamp(self.x, b.x + halfW, b.x + b.w - halfW)
	self.y = clamp(self.y, b.y + halfH, b.y + b.h - halfH)
end

function Camera:update(dt)
	local dx = self.tx - self.x
	local dy = self.ty - self.y
	if math.abs(dx) < self.deadzone then
		dx = 0
	end
	if math.abs(dy) < self.deadzone then
		dy = 0
	end
	local t = 1 - math.exp(-self.lerp * dt)
	self.x = self.x + dx * t
	self.y = self.y + dy * t
	self:applyBounds()
end

function Camera:attach()
	love.graphics.push()
	love.graphics.translate(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)
	love.graphics.scale(self.scale, self.scale)
	love.graphics.translate(-self.x, -self.y)
end

function Camera:detach()
	love.graphics.pop()
end

return Camera
