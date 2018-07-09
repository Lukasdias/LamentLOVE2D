local anim8 = require("libs/anim8")
function Ending_load()
    BackG = {}
    BackG.img = love.graphics.newImage("imagens/Menu/Final_Stage.png")

end 

function Ending_update(dt)
end

function Ending_draw()
    love.graphics.draw(BackG.img, 0, 0, 0, 1.2)
end