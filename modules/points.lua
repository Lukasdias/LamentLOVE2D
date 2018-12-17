anim8 = require("libs/anim8")

function  points_load(map, world)
-- TABELA ESCUDO E OLHO E A BARRA DE VIDA--
    currentLife = 1500
    Health = {}
    Health.posx = 0
    Health.posy = 100
    Health.img = love.graphics.newImage("imagens/Cruz/lifebar.png")
    Health.grid = anim8.newGrid(204, 30, Health.img:getWidth(), Health.img:getHeight())
    Health.anim = anim8.newAnimation(Health.grid('1-1', 1), 0.20)
    Health.anim2 = anim8.newAnimation(Health.grid('2-2', 1), 0.20)
    Health.anim3 = anim8.newAnimation(Health.grid('3-3', 1), 0.20)
    Health.anim4 = anim8.newAnimation(Health.grid('4-4', 1), 0.20)
    Health.anim5 = anim8.newAnimation(Health.grid('5-5', 1), 0.20)

    Shield = {}
    Shield.posx = 80
    Shield.posy = 105
    Shield.img = love.graphics.newImage("imagens/Cruz/laurence_shield.png")
    Shield.grid = anim8.newGrid(216, 216, Shield.img:getWidth(), Shield.img:getHeight())
    Shield.anim = anim8.newAnimation(Shield.grid('1-6', 1), 0.20)

    eye = {}
    eye.posx = 120
    eye.posy = 165 
    eye.img = love.graphics.newImage("imagens/Npcs/eyeball.png")
    eye.grid = anim8.newGrid(32, 32, eye.img:getWidth(), eye.img:getHeight())
    eye.anim = anim8.newAnimation(eye.grid('1-8',1, "1-8", 2, "1-8", 3), 0.08)
end


function points_update(dt)
    eye.anim:update(dt)
    Shield.anim:update(dt)
    Health.posx = px - 20
    Health.posy = py - 25
    -- A SEGUIR TODOS OS PONTOS DE SPAWN DA AUREA DE PROTEÇÃO E VISÃO DO SEMELHANTE--
    --primeiro spawn--
    if px >= 100 and px <= 135 and py >= 170 and py <= 180  then
        eye.posx, eye.posy = 230, 310
        currentLife = 1500
        safe = true
    --segundo spawn--
    elseif px >= 230 and px <= 245  and py >= 310 and py <= 325 then
        eye.posx, eye.posy = 25, 505
        Shield.posx, Shield.posy = 185, 245
        currentLife = 1500
        safe = true
    --terceiro spawn--
    elseif px >= 10 and px <= 40  and py >= 510 and py <= 520 then
        eye.posx, eye.posy = 285, 525
        Shield.posx, Shield.posy = -15, 440
        currentLife = 1500
        safe = true
    --quarto spawn--
    elseif px >= 270 and px <= 300 and py >= 540 and py <= 550 then
        eye.posx, eye.posy = 485, 535
        Shield.posx, Shield.posy = 240, 469
        currentLife = 1500
        safe = true
       
    --quinto spawn-- 
    elseif px >= 470 and px <= 510 and py >= 540 and py <= 550 then
        eye.posx, eye.posy = 630, 190
        Shield.posx, Shield.posy = 450, 470
        currentLife = 1750
        safe = true
    --sexto spawn--
    elseif px >= 585 and px <= 655 and py >= 165 and py <= 225 then
        eye.posx, eye.posy = 500, 158
        Shield.posx, Shield.posy = 585, 115
        currentLife = 1500
        safe = true
        --sétimo spawn--
    elseif px >= 500 and px <= 520 and py >= 155 and py <= 165 then
        eye.posx, eye.posy = 800, 800 -- vai para fora do mapa
        currentLife = 1500
        Shield.posx, Shield.posy = 460, 85
        safe = true
    else
        currentLife = currentLife - 1
        safe = false
    end

    --nerf de velociade no terceiro andar do mapa--
    if px >= 75 and px <= 500 and py >= 520 and py <= 550 then
        forceR = 75
        forceL = - 75
        nerf = true
    else 
        forceL = -100
        forceR = 100
        nerf = false
    end
end

function points_draw()
    eye.anim:draw(eye.img, eye.posx , eye.posy, 0, 1, 1, 12, 0)
    if safe then
        Shield.anim:draw(Shield.img, Shield.posx, Shield.posy, 0, 0.5, 0.6, 12, 0)
    end
    if currentLife > 1200 and currentLife <= 1750 then
        love.graphics.print("HEALTH", Health.posx + 3, Health.posy - 8, 0, 0.8, 0.5)
        Health.anim:draw(Health.img, Health.posx, Health.posy, 0, 0.2, 0.2)
    elseif currentLife < 1200 and currentLife >= 800 then
        love.graphics.print("HEALTH", Health.posx + 3, Health.posy - 8, 0, 0.8, 0.5)
        Health.anim2:draw(Health.img, Health.posx, Health.posy, 0, 0.2, 0.2)
    elseif currentLife < 800 and currentLife >=500 then
        love.graphics.print("HEALTH", Health.posx + 3, Health.posy - 8, 0, 0.8, 0.5)
        Health.anim3:draw(Health.img, Health.posx, Health.posy, 0, 0.2, 0.2)
    elseif currentLife < 500 and currentLife >= 200  then
        love.graphics.print("HEALTH", Health.posx + 3, Health.posy - 8, 0, 0.8, 0.5)
        Health.anim4:draw(Health.img, Health.posx, Health.posy, 0, 0.2, 0.2)
    elseif currentLife < 200 and currentLife >= 0 then 
        love.graphics.print("HEALTH", Health.posx + 3, Health.posy - 8, 0, 0.8, 0.5)
        Health.anim5:draw(Health.img, Health.posx, Health.posy, 0, 0.2, 0.2)
    end
end
