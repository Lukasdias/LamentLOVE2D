local SpriteSheet = require("modules.sprite_sheet")
local Animation = require("modules.animation")

local Enemy = {}
Enemy.__index = Enemy

-- An enemy is one sprite, one animation, and a horizontal patrol between two
-- bounds. Kind-specific data lives in enemy_kinds.lua; behavior lives here.
function Enemy.new(spec)
	local self = setmetatable({}, Enemy)
	self.name = spec.name
	self.x = spec.x or 0
	self.y = spec.y or 0
	self.speed = spec.speed or 0.5
	self.minX = spec.minX or 0
	self.maxX = spec.maxX or 0
	self.direction = spec.direction or 1
	self.originX = spec.originX or 0
	self.originY = spec.originY or 0
	self.alive = true

	self.sheet = SpriteSheet.new(spec.image)
	local frames = spec.frames
	assert(frames and #frames > 0, "enemy " .. tostring(spec.name) .. ": no frames")
	for _, rect in ipairs(frames) do
		assert(self.sheet:contains(rect),
			("enemy %s frame out of bounds (%d,%d,%d,%d)"):format(
				self.name, rect.x, rect.y, rect.w, rect.h))
	end
	self.anim = Animation.new(self.sheet, frames, spec.fps or 0.09)
	return self
end

function Enemy:update(dt)
	if not self.alive then
		return
	end
	self.anim:update(dt)
	self.x = self.x + self.speed * self.direction
	if self.x >= self.maxX then
		self.direction = -1
	elseif self.x <= self.minX then
		self.direction = 1
	end
end

function Enemy:draw()
	self.anim:draw(self.x, self.y, self.direction, self.originX, self.originY)
end

return Enemy
