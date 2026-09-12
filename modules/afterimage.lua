local Afterimage = {}
Afterimage.__index = Afterimage

function Afterimage.new(opts)
	opts = opts or {}
	local self = setmetatable({}, Afterimage)
	self.interval = opts.interval or 0.045
	self.life = opts.life or 0.28
	self.maxCount = opts.maxCount or 20
	self.tint = opts.tint or { 0.65, 0.85, 1.0 }
	self.alpha = opts.alpha or 0.55
	self.shrink = opts.shrink or 0.10
	self.timer = 0
	self.items = {}
	return self
end

function Afterimage:reset()
	self.timer = 0
	self.items = {}
end

function Afterimage:emit(anim, img, x, y, facing, originX, dt)
	self.timer = self.timer + dt
	if self.timer < self.interval then
		return
	end
	self.timer = self.timer - self.interval

	local info = { anim:getFrameInfo(x, y, 0, facing, 1, originX, 0) }
	local _, _, _, h = info[1]:getViewport()
	self.items[#self.items + 1] = {
		img = img,
		info = info,
		x = x,
		y = y,
		h = h,
		life = self.life,
		max = self.life,
	}
	while #self.items > self.maxCount do
		table.remove(self.items, 1)
	end
end

function Afterimage:idle()
	self.timer = 0
end

function Afterimage:update(dt)
	for i = #self.items, 1, -1 do
		local g = self.items[i]
		g.life = g.life - dt
		if g.life <= 0 then
			table.remove(self.items, i)
		end
	end
end

function Afterimage:draw()
	local tint = self.tint
	for i = 1, #self.items do
		local g = self.items[i]
		local t = g.life / g.max
		local alpha = (t ^ 1.5) * self.alpha
		local scale = (1 - self.shrink) + self.shrink * t
		local pivotY = g.y + g.h / 2

		love.graphics.setColor(tint[1], tint[2], tint[3], alpha)
		love.graphics.push()
		love.graphics.translate(g.x, pivotY)
		love.graphics.scale(scale, scale)
		love.graphics.translate(-g.x, -pivotY)
		love.graphics.draw(g.img, unpack(g.info))
		love.graphics.pop()
	end
	love.graphics.setColor(1, 1, 1, 1)
end

return Afterimage
