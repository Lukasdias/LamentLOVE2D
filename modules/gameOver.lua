local anim8 = require("libs/anim8")

function gameOverLoad()
   gameOver = {}
   gameOver.Bg = love.graphics.newImage("images/Menu/gameoverBG.jpg")
   gameOver.title = love.graphics.newImage("images/Menu/gameoverTitle.png")
   gameOver.grid = anim8.newGrid(384, 102,gameOver.title:getWidth(), gameOver.title:getHeight())
   gameOver.anim = anim8.newAnimation(gameOver.grid('1-20',1), 0.08)
end 

function gameOverUpdate(dt)
    gameOver.anim:update(dt)
    if gamestate == "Game Over" then
        songs_update()
    end
end 

function gameOverDraw()
    love.graphics.draw(gameOver.Bg, 0, 0)
    gameOver.anim:draw(gameOver.title, 190, screenHeight/2 - 100)
end

