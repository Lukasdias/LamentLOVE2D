
local anim8 = require("libs/anim8")

buttonLib = require ("libs/button")

local start
local Title, TitleAnimation, Titlegrid
function menu_load()
    --flag que define o estado de jogo inicial como o menu do jogo--
    gamestate = "title"
    --Background--
    menu_image = love.graphics.newImage("imagens/menu/Menu_Image.jpg")
    --utilizando a anim8 para animar o menu--
     Title = love.graphics.newImage("imagens/menu/Main_Title.png")
    --cortando frame por frame usando anim8--
     Titlegrid = anim8.newGrid(756, 108, Title:getWidth(), Title:getHeight())
     --defininado como será a animação--
     TitleAnimation = anim8.newAnimation(Titlegrid('1-1', 1,'1-1', 2,'1-1', 3,'1-1', 4,'1-1', 5,'1-1', 6,'1-1', 7,'1-1', 8,'1-1', 9,'1-1', 10,'1-1', 11,'1-1', 12,'1-1', 13,'1-1', 14,'1-1', 15,'1-1', 16,'1-1', 17,'1-1', 18,'1-1', 19,'1-1', 20),  0.1)
    --creditos-- 
    credits_image = love.graphics.newImage("imagens/menu/credits.png")

    start_button = buttonLib:new("Start", 280, 40, 245, 400, {128,0,0}, function() play = true  end)
    quit_button = buttonLib:new("Give Up", 280, 40, 245, 500, {128,0,0}, function() love.event.quit()  end)
    --help_button = buttonLib:new("Wiki and Tutorial", 280, 40, 245, 450, {128,0,0}, function() tutorial = true  end)
end

function menu_update(dt)
    TitleAnimation:update(dt)
    if play then
        if gamestate == "title" then
            gamestate = "play"
        end
    end
    if tutorial then
        if gamestate == "title" then
            gamestate = "tutorial"
        end
    end
end

function menu_draw()
    love.graphics.draw(menu_image, 0, 0, 0, 1.5, 1)
    TitleAnimation:draw(Title, 5, 5)
    love.graphics.draw(credits_image, 0, 550)
    start_button.draw()
    quit_button:draw()
    love.graphics.setColor(255, 255, 255)
end
