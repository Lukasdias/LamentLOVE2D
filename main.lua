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
gamestate = "title"

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
		songs_update()
	elseif gamestate == "play" then
		Map_update(dt)
		Laurence_update(dt)
		points_update(dt)
		npc_update(dt)
		points_update(dt)
		songs_update()
	elseif gamestate == "Game Over" then
		gameover_update(dt)
		songs_update()
	elseif gamestate == "Ending" then
		Ending_update(dt)
		songs_update()
	end
end

function love.draw()
  if gamestate == "title" then
		menu_draw()
  elseif gamestate == "play" then
		camera:attach()
		Map_draw()
		Laurence_draw()
		npc_draw()
		points_draw()
		camera:detach()
		camera:draw()	
  elseif gamestate == "Game Over" then
		gameover_draw()
  elseif gamestate == "Ending" then
		Ending_draw()
  end
end

function love.keyreleased(key)
	if gamestate == "play" then
		last_keyreleased(key)
	end
end


function love.keypressed(key)
	if gamestate == "Game Over" and key == "return" then 
		love.audio.stop(death_theme)
		gamestate = "play"
		love.load()
	elseif gamestate == "Ending" and key == "return" then
		love.audio.stop(win_theme)
		gamestate = "play"
		love.load()
	end

	if gamestate == "play" then
		jump_config(key)
	end
end


function love.mousemoved(x,y)
	if gamestate == "title" then
		start_button.mousemoved(x,y)
		quit_button.mousemoved(x,y)
	end
end
  
function love.mousepressed(x,y,b,it)
	if gamestate == "title" then
		start_button.mousepressed(x,y,b)
		quit_button.mousepressed(x,y,b)
	end
end

