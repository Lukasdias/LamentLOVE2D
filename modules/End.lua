local anim8 = require("libs/anim8")
function Ending_load()
    End_bg = love.graphics.newImage("imagens/Menu/End2_Background.png")
    End_bg_grid = anim8.newGrid(960, 540, End_bg:getWidth(), End_bg:getHeight())
    End_bg_anim = anim8.newAnimation(End_bg_grid('1-5', 1, '1-5', 2, '1-5', 3, '1-5', 4, '1-5', 5, '1-5', 6, '1-5', 7, '1-5', 8, '1-5', 9, '1-5', 10, '1-5', 11, '1-5', 12), 0.09) 
    BackG = {}
    BackG.title1 = love.graphics.newImage("imagens/Menu/Press_Enter.png")
    BackG.title2 = love.graphics.newImage("imagens/Menu/Congratulations2.png")
    BackG.title3 = love.graphics.newImage("imagens/Menu/Congratulations.png")
end 

function Ending_update(dt)
	End_bg_anim:update(dt)
end

function Ending_draw()
    End_bg_anim:draw(End_bg, 0, 0, 0 , 0.85, 1.3, 12, 0)
    love.graphics.draw(BackG.title1, 100, 400, 0)
    love.graphics.draw(BackG.title2, 20, 250, 0)
    love.graphics.draw(BackG.title3, 120, 50, 0)
end

