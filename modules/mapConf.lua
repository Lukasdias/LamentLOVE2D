local sti = require("sti") -- require na lib STI(SIMPLE TILED IMPLEMENTATION)
function mapLoad()
	mapImage = love.graphics.newImage("map/Map_1.png")
	love.physics.setMeter(64)
	map = sti("map.lua", {"box2d"}) -- declacara o map, além de requisitar a lib STI e solicitar o pluguin da Box2d-- 
	world = love.physics.newWorld(0, 9.81*64, true) --cria um mundo com grav. horizontal de 9.81--
	-- Scan the layer table for the Tiled layer named "ground" and register its
	-- tiles with the physics world.
	for i = 1, #map.layers do
		if map.layers.name == "Ground" then
			for j = 1, #map.layers[i] do 
                world:add(map.layer[i].Ground[j], map.layer[i].Ground[j].x,  map.layer[i].Ground[j].y)
            end
        end
	end
	map:box2d_init(world)
end



function mapUpdate(dt)
	map:update(dt)
	world:update(dt)
end

function mapDraw()
	camera:attach()	
	love.graphics.draw(mapImage, 0, 0);	
	playerDraw()
	enemyManager:draw()
	pointsDraw()
	camera:detach()
	--map:box2d_draw(0, 0, 2, 2.7)
end