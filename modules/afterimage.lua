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

function Afterimage:emit(sheet, rect, x, y, facing, originX, dt)
	if not rect then
		return
	end
	self.timer = self.timer + dt
	if self.timer < self.interval then
		return
	end
	self.timer = self.timer - self.interval

	self.items[#self.items + 1] = {
		sheet = sheet,
		rect = rect,
		x = x,
		y = y,
		originX = originX,
		facing = facing,
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
		local pivotY = g.y + g.rect.h / 2

		love.graphics.setColor(tint[1], tint[2], tint[3], alpha)
		love.graphics.push()
		love.graphics.translate(g.x, pivotY)
		love.graphics.scale(scale, scale)
		love.graphics.translate(-g.x, -pivotY)
		love.graphics.draw(g.sheet.image, g.sheet:quad(g.rect), g.x, g.y, 0, g.facing, 1,
			g.originX, g.rect.h)
		love.graphics.pop()
	end
	love.graphics.setColor(1, 1, 1, 1)
end

return Afterimage
