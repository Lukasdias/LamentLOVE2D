anim8 = require("libs/anim8")

function  pointsLoad(map, world)
-- TABELA ESCUDO E OLHO E A BARRA DE VIDA--
    currentLife = 1500
    --Barra de Vida--
    hp = {}
    hp.posx = 10
    hp.posy = 0
    hp.img = love.graphics.newImage("imagens/Cruz/lifebar.png")
    hp.grid = anim8.newGrid(57, 20, hp.img:getWidth(), hp.img:getHeight())
    hp.anim = anim8.newAnimation(hp.grid('4-4', 1), 0.20)
    hp.anim2 = anim8.newAnimation(hp.grid('3-3', 1), 0.20)
    hp.anim3 = anim8.newAnimation(hp.grid('2-2', 1), 0.20)
    hp.anim4 = anim8.newAnimation(hp.grid('1-1', 1), 0.20)
    --Aura de proteção--
    shield = {}
    shield.posx = 80
    shield.posy = 105
    shield.img = love.graphics.newImage("imagens/Cruz/laurence_shield.png")
    shield.grid = anim8.newGrid(216, 216, shield.img:getWidth(), shield.img:getHeight())
    shield.anim = anim8.newAnimation(shield.grid('1-6', 1), 0.20)
    --Olhos colecionaveis--
    eye = {}
    eye.posx = 120
    eye.posy = 165
    eye.img = love.graphics.newImage("imagens/Npcs/eyeball.png")
    eye.grid = anim8.newGrid(32, 32, eye.img:getWidth(), eye.img:getHeight())
    eye.anim = anim8.newAnimation(eye.grid('1-8',1, "1-8", 2, "1-8", 3), 0.08)
end


function pointsUpdate(dt)
    local px, py = laurence.body:getPosition()    
    --Atualizando animações--
    eye.anim:update(dt)
    shield.anim:update(dt)
    --Posicionando a barra de vida--
    hp.posx = px - 15
    hp.posy = py - 32
    -- A SEGUIR TODOS OS PONTOS DE SPAWN DA AUREA DE PROTEÇÃO E VISÃO DO SEMELHANTE--
    --primeiro spawn--
    if (px >= 100 and px <= 135 and py >= 170 and py <= 180) then
        eye.posx, eye.posy = 230, 310
        if(love.keyboard.isDown == "down") then
            currentLife = 1500
            safe = true
        end
    --segundo spawn--
    elseif px >= 230 and px <= 245  and py >= 310 and py <= 325 then
        eye.posx, eye.posy = 25, 505
        shield.posx, shield.posy = 185, 245
        if(love.keyboard.isDown == "down") then
            currentLife = 1500
            safe = true
        end
    --terceiro spawn--
    elseif px >= 10 and px <= 40  and py >= 510 and py <= 520 then
        eye.posx, eye.posy = 285, 525
        shield.posx, shield.posy = -15, 440
        if(love.keyboard.isDown == "down") then
            currentLife = 1500
            safe = true
        end
    --quarto spawn--
    elseif px >= 270 and px <= 300 and py >= 540 and py <= 550 then
        eye.posx, eye.posy = 485, 535
        shield.posx, shield.posy = 240, 469
        if(love.keyboard.isDown == "down") then
            currentLife = 1500
            safe = true
        end 
    --quinto spawn-- 
    elseif px >= 470 and px <= 510 and py >= 540 and py <= 550 then
        eye.posx, eye.posy = 630, 190
        shield.posx, shield.posy = 450, 470
        if(love.keyboard.isDown == "down") then
            currentLife = 1500
            safe = true
        end
    --sexto spawn--
    elseif px >= 585 and px <= 655 and py >= 165 and py <= 225 then
        eye.posx, eye.posy = 500, 158
        shield.posx, shield.posy = 585, 115
        if(love.keyboard.isDown == "down") then
            currentLife = 1500
            safe = true
        end
        --sétimo spawn--
    elseif px >= 500 and px <= 520 and py >= 155 and py <= 165 then
        eye.posx, eye.posy = 800, 800 -- vai para fora do mapa
        shield.posx, shield.posy = 460, 85
        if(love.keyboard.isDown == "h") then
            currentLife = 1500
            safe = true
        end
    else
        currentLife = currentLife - 1
        safe = false
    end
end

function pointsDraw()
    eye.anim:draw(eye.img, eye.posx , eye.posy, 0, 1, 1, 12, 0)
    --love.graphics.print("Your hp time is: " .. currentLife, 0, 10, 0, 1.5, 1.5)
    if safe then
        shield.anim:draw(shield.img, shield.posx, shield.posy, 0, 0.5, 0.6, 12, 0)
    end

    if currentLife > 1200 and currentLife <= 1750 then
        hp.anim:draw(hp.img, hp.posx, hp.posy, 0, 0.5, 0.5)
    elseif currentLife < 1200 and currentLife >= 800 then
        hp.anim2:draw(hp.img, hp.posx, hp.posy, 0, 0.5, 0.5)
    elseif currentLife < 800 and currentLife >=500 then
        hp.anim3:draw(hp.img, hp.posx, hp.posy, 0, 0.5, 0.5)
    elseif currentLife < 500 and currentLife >= 0  then
        hp.anim4:draw(hp.img, hp.posx, hp.posy, 0, 0.5, 0.5)
    end
end
