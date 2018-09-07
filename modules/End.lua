local anim8 = require("libs/anim8")
function Ending_load()
    End_bg = love.graphics.newImage("imagens/Menu/End2_Background.png")
    End_bg_grid = anim8.newGrid(960, 540, End_bg:getWidth(), End_bg:getHeight())
    End_bg_anim = anim8.newAnimation(End_bg_grid('1-5', 1), 0.08) 
    BackG = {}
    BackG.img = love.graphics.newImage("imagens/Menu/Final_Stage.png")
    BackG.title1 = love.graphics.newImage("imagens/Menu/Press_Enter.png")
    BackG.title2 = love.graphics.newImage("imagens/Menu/Congratulations2.png")
    BackG.title3 = love.graphics.newImage("imagens/Menu/Congratulations.png")
end 

function Ending_update(dt)
	End_bg_anim:update(dt)
end

function Ending_draw()
    End_bg_anim:draw(End_bg, 0, 0, 0 , 1, 1.3, 12, 0)
    --love.graphics.draw(BackG.img, 0, 0, 0, 1, 1.2)
    love.graphics.draw(BackG.title1, 100, 400, 0)
    love.graphics.draw(BackG.title2, 20, 250, 0)
    love.graphics.draw(BackG.title3, 120, 50, 0)
end

