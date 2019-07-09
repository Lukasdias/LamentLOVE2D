local sti = require("sti") -- require na lib STI(SIMPLE TILED IMPLEMENTATION)
function mapLoad()
	mapImage = love.graphics.newImage("map/Map_1.png")
	love.physics.setMeter(64)
	map = sti("map.lua", {"box2d"}) -- declacara o map, além de requisitar a lib STI e solicitar o pluguin da Box2d-- 
	world = love.physics.newWorld(0, 9.81*64, true) --cria um mundo com grav. horizontal de 9.81--
	--Laço que procura na tabela layer o item criado no tiled chamado "ground", após encontra-lo o implementa no mapa, com seus respectivos dados.--
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
	npcDraw()
	pointsDraw()
	camera:detach()
	--map:box2d_draw(0, 0, 2, 2.7)
end