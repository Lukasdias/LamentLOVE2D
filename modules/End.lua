local anim8 = require("libs/anim8")
function Ending_load()
    BackG = {}
    BackG.img = love.graphics.newImage("imagens/Menu/Final_Stage.png")
    BackG.title1 = love.graphics.newImage("imagens/Menu/Press_Enter.png")
    BackG.title2 = love.graphics.newImage("imagens/Menu/Congratulations2.png")
    BackG.title3 = love.graphics.newImage("imagens/Menu/Congratulations.png")
end 

function Ending_update(dt)
end

function Ending_draw()
    love.graphics.draw(BackG.img, 0, 0, 0, 1, 1.2)
    love.graphics.draw(BackG.title1, 100, 400, 0)
    love.graphics.draw(BackG.title2, 20, 250, 0)
    love.graphics.draw(BackG.title3, 120, 50, 0)
end