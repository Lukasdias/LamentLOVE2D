local sti = require("sti") -- require na lib STI(SIMPLE TILED IMPLEMENTATION)
function Map_load()
	map = sti("map.lua", {"box2d"}) -- declacara o map, além de requisitar a lib STI e solicitar o pluguin da Box2d-- 
	MapLayer = map:addCustomLayer("map", 1)
	love.physics.setMeter(32) --1 metro = 32 px
  	world = love.physics.newWorld(0, 9.81*32) --cria um mundo com grav. horizontal de 9.81--
	--Laço que procura na tabela layer o item criado no tiled chamado "ground", após encontra-lo o implementa no mapa, com seus respectivos dados.--
	for i = 1, #map.layers do
		if map.layers.name == "Ground" then
			for j = 1, #map.layers[i] do 
                    world:add(map.layer[i].Ground[j], map.layer[i].Ground[j].x,  map.layer[i].Ground[j].y)
				end
        end
	end
	map:box2d_init(world) -- inicia o mundo atraves da box2d
	mapa = love.graphics.newImage("map/Map_1.png")
end

function Map_update(dt)
	map:update(dt)
	world:update(dt)
end

function Map_draw()
	love.graphics.draw(mapa, 0, 0)
end