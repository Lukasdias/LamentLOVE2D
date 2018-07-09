require("modules/laurence")
require("modules/map_conf")
require("modules/menu")
require("modules/Ost")
require("modules/npc")
require("modules/points")
require("modules/GameOver")
require("modules/End")

largura = love.graphics.getWidth()
altura = love.graphics.getHeight()

function love.keyreleased(key)
	last_keyreleased(key)
end

--[[function love.keypressed(key)
	if key == backspace then
		if gamestate == "tutorial" then
			gamestate = "title"
			back = true
		end
	end
end--]]


function love.load()	
	Map_load()
	menu_load()
	songs_load()
	npc_load(map)
	Laurence_load(map, world)
	points_load(map, world)
	gameover_load()
	Ending_load()
end

function love.update(dt)
	if gamestate == "title" then
		menu_update(dt)
	elseif gamestate == "play" then
		Map_update(dt)
		Laurence_update(dt)
		points_update(dt)
		npc_update(dt)
		points_update(dt)
	elseif gamestate == "Game Over" then
		gameover_update(dt)
	elseif gamestate == "Ending" then
		Ending_update(dt)
	end
end

function love.draw()
  if gamestate == "title" then
		menu_draw()
  elseif gamestate == "play" then
		Map_draw()
  elseif gamestate == "Game Over" then
		gameover_draw()
  elseif gamestate == "Ending" then
	Ending_draw()
  end
end

function love.keypressed(key)
end


function love.mousemoved(x,y)
    start_button.mousemoved(x,y)
    quit_button.mousemoved(x,y)
end
  
function love.mousepressed(x,y,b,it)
    start_button.mousepressed(x,y,b)
    quit_button.mousepressed(x,y,b)
end

