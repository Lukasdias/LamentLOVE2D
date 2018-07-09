function tutorial_load()
Background = love.graphics.newImage("imagens/menu/Menu_Image.jpg")
instructions = love.graphics.newImage("imagens/menu/instructions.png")
instructions_title = love.graphics.newImage("imagens/menu/instructions_title.png")
end 

function tutorial_update(dt)
    if back == true then
        gamestate = "title"
    else
        back = false
    end
end

function tutorial_draw()
    love.graphics.draw(Background, 0, 0, 0, 1.5, 1)
    love.graphics.draw(instructions, 45, 250)
    love.graphics.draw(instructions_title, 170, 0)
end



