local Enemy = require("modules.enemy")
local kinds = require("modules.enemy_kinds")

local Manager = {}
Manager.__index = Manager

function Manager.new()
	local self = setmetatable({}, Manager)
	self.enemies = {}
	self.byName = {}
	return self
end

function Manager:spawnAll()
	for _, spec in ipairs(kinds()) do
		local e = Enemy.new(spec)
		self.enemies[#self.enemies + 1] = e
		self.byName[e.name] = e
	end
	return self
end

function Manager:get(name)
	return self.byName[name]
end

function Manager:update(dt)
	for _, e in ipairs(self.enemies) do
		e:update(dt)
	end
end

function Manager:draw()
	for _, e in ipairs(self.enemies) do
		e:draw()
	end
end

return Manager
