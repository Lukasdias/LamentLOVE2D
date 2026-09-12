local anim8 = require("libs/anim8")

-- Per-kind enemy definitions. Each kind owns its sheet frames and patrol data;
-- behavior stays in enemy.lua. `range` mirrors the original npc.lua animations.
local function gridFrames(image, fw, fh, ranges)
	local sheet = love.graphics.newImage(image)
	local grid = anim8.newGrid(fw, fh, sheet:getWidth(), sheet:getHeight())
	local args = {}
	for _, r in ipairs(ranges) do
		args[#args + 1] = r
	end
	local frames = grid(unpack(args))
	local out = {}
	for _, q in ipairs(frames) do
		local x, y, w, h = q:getViewport()
		out[#out + 1] = { x = x, y = y, w = w, h = h }
	end
	return out
end

return function()
	return {
		{
			name = "ghost",
			image = "images/Npcs/ghost_blue.png",
			frames = gridFrames("images/Npcs/ghost_blue.png", 37, 65, { "1-4", 1 }),
			fps = 0.09,
			x = 10, y = 25,
			minX = 10, maxX = 300,
			speed = 1,
			originX = 12, originY = 0,
		},
		{
			name = "ghost2",
			image = "images/Npcs/ghost.png",
			frames = gridFrames("images/Npcs/ghost.png", 37, 65, { "1-4", 1 }),
			fps = 0.09,
			x = 300, y = 25,
			minX = 300, maxX = 600,
			speed = 1,
			originX = 12, originY = 0,
		},
		{
			name = "medusa",
			image = "images/Npcs/Medusa.png",
			frames = gridFrames("images/Npcs/Medusa.png", 57, 88, { "1-8", 1 }),
			fps = 0.09,
			x = 205, y = 400,
			minX = 200, maxX = 450,
			speed = 0.5,
			originX = 24, originY = 0,
		},
		{
			name = "mummy",
			image = "images/Npcs/mummy.png",
			frames = gridFrames("images/Npcs/mummy.png", 37, 45,
				{ "1-5", 1, "1-5", 2, "1-5", 3, "1-3", 4 }),
			fps = 0.08,
			x = 120, y = 516,
			minX = 125, maxX = 500,
			speed = 1,
			originX = 13, originY = 0,
		},
	}
end
