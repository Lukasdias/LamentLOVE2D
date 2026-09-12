local Button = {}
Button.__index = Button

local function inside(px, py, x, y, w, h)
	return px >= x and px <= x + w and py >= y and py <= y + h
end

function Button.new(opts)
	local self = setmetatable({}, Button)
	self.label = opts.label or ""
	self.x = opts.x or 0
	self.y = opts.y or 0
	self.w = opts.w or 160
	self.h = opts.h or 40
	self.font = opts.font
	self.colors = opts.colors or {}
	self.onClick = opts.onClick or function() end
	self.hovered = false
	self.focused = false
	self.pulse = 0
	return self
end

function Button:center(spacing, index, startY)
	self.x = (love.graphics.getWidth() - self.w) / 2
	self.y = startY + (index - 1) * (self.h + (spacing or 0))
end

function Button:contains(x, y)
	return inside(x, y, self.x, self.y, self.w, self.h)
end

function Button:setHover(x, y)
	self.hovered = self:contains(x, y)
end

function Button:mousepressed(x, y, button)
	if button == 1 and self:contains(x, y) then
		self.onClick()
		return true
	end
	return false
end

function Button:activate()
	if self.focused then
		self.onClick()
	end
end

function Button:update(dt)
	local active = self.hovered or self.focused
	local target = active and 1 or 0
	local speed = 10
	self.pulse = self.pulse + (target - self.pulse) * math.min(1, speed * dt)
end

function Button:draw()
	local font = self.font
	love.graphics.setFont(font)

	local base = self.colors.bg
	local hover = self.colors.hover
	local focus = self.colors.focus
	local border = self.colors.border
	local text = self.colors.text

	local p = self.pulse
	local grown = p * 4
	local x, y = self.x - grown / 2, self.y - grown / 2
	local w, h = self.w + grown, self.h + grown

	local c = focus
	if not self.focused and self.hovered then
		c = hover
	end
	love.graphics.setColor(c)
	love.graphics.rectangle("fill", x, y, w, h, 4, 4)

	local bc = (self.focused or self.hovered) and border or base
	love.graphics.setColor(bc)
	love.graphics.setLineWidth(2)
	love.graphics.rectangle("line", x, y, w, h, 4, 4)
	love.graphics.setLineWidth(1)

	local tw = font:getWidth(self.label)
	local th = font:getHeight()
	love.graphics.setColor(text)
	if self.focused then
		local glow = 0.5 + 0.5 * math.sin(love.timer.getTime() * 6)
		love.graphics.setColor(text[1], text[2], text[3], 0.55 + 0.35 * glow)
	end
	love.graphics.print(self.label, self.x + (self.w - tw) / 2, self.y + (self.h - th) / 2)

	love.graphics.setColor(1, 1, 1, 1)
end

return Button
