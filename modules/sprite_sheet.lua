local SpriteSheet = {}
SpriteSheet.__index = SpriteSheet

function SpriteSheet.new(path)
	local self = setmetatable({}, SpriteSheet)
	self.image = love.graphics.newImage(path)
	self.image:setFilter("nearest", "nearest")
	self.width = self.image:getWidth()
	self.height = self.image:getHeight()
	self.quads = {}
	return self
end

function SpriteSheet:quad(rect)
	local key = rect.x .. "," .. rect.y .. "," .. rect.w .. "," .. rect.h
	local q = self.quads[key]
	if not q then
		q = love.graphics.newQuad(rect.x, rect.y, rect.w, rect.h, self.width, self.height)
		self.quads[key] = q
	end
	return q
end

function SpriteSheet:contains(rect)
	return rect.x >= 0 and rect.y >= 0
		and rect.x + rect.w <= self.width
		and rect.y + rect.h <= self.height
		and rect.w > 0 and rect.h > 0
end

return SpriteSheet
