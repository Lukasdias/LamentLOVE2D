local anim8 = require("libs/anim8")

function gameover_load()
   gameOver = {}
   gameOver.Bg = love.graphics.newImage("imagens/Menu/Game_Over.jpg")
   gameOver.title = love.graphics.newImage("imagens/Menu/Game_Over_Title.png")
   gameOver.grid = anim8.newGrid(384, 102,gameOver.title:getWidth(), gameOver.title:getHeight())
   gameOver.anim = anim8.newAnimation(gameOver.grid('1-20',1), 0.08)
end 

function gameover_update(dt)
    gameOver.anim:update(dt)
    if gamestate == "Game Over" then
        songs_update()
    end
end 

function gameover_draw()
    love.graphics.draw(gameOver.Bg, 0, 0)
    gameOver.anim:draw(gameOver.title, 190, altura/2 - 100)
end

