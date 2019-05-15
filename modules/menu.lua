
local anim8 = require("libs/anim8")

buttonLib = require ("libs/button")

local start
local Title, TitleAnimation, Titlegrid
function menu_load()
    --flag que define o estado de jogo inicial como o menu do jogo--
    gamestate = "title"
    --Background--
    menu_image = love.graphics.newImage("imagens/menu/Menu_Background.png")
    menu_grid = anim8.newGrid(768, 384, menu_image:getWidth(), menu_image:getHeight())
    menu_anim =  anim8.newAnimation(menu_grid("1-9", 1, "1-9", 2, "1-9", 3), 0.08)
    --utilizando a anim8 para animar o menu--
     Title = love.graphics.newImage("imagens/menu/Main_Title.png")
    --cortando frame por frame usando anim8--
     Titlegrid = anim8.newGrid(756, 108, Title:getWidth(), Title:getHeight())
     --defininado como será a animação--
     TitleAnimation = anim8.newAnimation(Titlegrid('1-1', 1,'1-1', 2,'1-1', 3,'1-1', 4,'1-1', 5,'1-1', 6,'1-1', 7,'1-1', 8,'1-1', 9,'1-1', 10,'1-1', 11,'1-1', 12,'1-1', 13,'1-1', 14,'1-1', 15,'1-1', 16,'1-1', 17,'1-1', 18,'1-1', 19,'1-1', 20),  0.1)
    --creditos-- 
    credits_image = love.graphics.newImage("imagens/menu/credits.png")

    start_button = buttonLib:new("Start", 180, 40, 485, 375, {128,0,0}, function() play = true  end)
    quit_button = buttonLib:new("Give Up", 180, 40, 485, 450, {128,0,0}, function() love.event.quit()  end)
    --help_button = buttonLib:new("Wiki and Tutorial", 280, 40, 245, 450, {128,0,0}, function() tutorial = true  end)
end

function menu_update(dt)
    menu_anim:update(dt)
    TitleAnimation:update(dt)
    if play then
        if gamestate == "title" then
            gamestate = "play"
        end
    end
end

function menu_draw()
    menu_anim:draw(menu_image, 0, 0, 0 , 1.1, 1.55, 12, 0)
    TitleAnimation:draw(Title, 5, 5)
    love.graphics.draw(credits_image, 0, 550)
    start_button.draw()
    quit_button:draw()
    love.graphics.setColor(255, 255, 255)
end
