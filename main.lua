require("modules/player")
require("modules/mapConf")
require("modules/menu")
require("modules/sound")
require("modules/enemy_manager")
require("modules/points")
require("modules/gameOver")
require("modules/endGame")

local EnemyManager = require("modules.enemy_manager")
enemyManager = EnemyManager.new()

screenWidth = love.graphics.getWidth()
screenHeight = love.graphics.getHeight()

function love.keyreleased(key)
	lastKey(key)
end


function love.load()	
	mapLoad()
	menuLoad()
	--soundLoad()
	gameOverLoad()
	endLoad()
	enemyManager:spawnAll()
	playerLoad(map, world)
	pointsLoad(map, world)
end

function love.update(dt)
	if gamestate == "menu" then
		menuUpdate(dt)
		--soundUpdate()
	elseif gamestate == "play" then
		mapUpdate(dt)
		playerUpdate(dt, laurence)
		pointsUpdate(dt)
		enemyManager:update(dt)
		pointsUpdate(dt)
		--soundUpdate()
	elseif gamestate == "death" then
		gameOverUpdate(dt)
		--soundUpdate()
	elseif gamestate == "end" then
		endUpdate(dt)
		--soundUpdate()
	end
end

function love.draw()
  if gamestate == "menu" then
		menuDraw()
  elseif gamestate == "play" then
		mapDraw()
  elseif gamestate == "death" then
		gameOverDraw()
  elseif gamestate == "end" then
		endDraw()
  end
end

function love.keypressed(key)
	if gamestate == "menu" then
		menuKeypressed(key)
	end

	if(gamestate == "play") then
		playerJump(key)
	end

	if gamestate == "death" and key == "return" then 
		--love.audio.stop(death_theme)
		gamestate = "play"
		love.load()
	elseif gamestate == "end" and key == "return" then
		--love.audio.stop(win_theme)
		gamestate = "play"
		love.load()
	end
end


function love.mousemoved(x,y)
	if gamestate == "menu" then
		menuMousemoved(x,y)
	end
end
  
function love.mousepressed(x,y,b,it)
	if gamestate == "menu" then
		menuMousepressed(x,y,b)
	end
end

