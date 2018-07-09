anim8 = require("libs/anim8")

function  points_load(map, world)

    --eyeLayer = map:addCustomLayer("Eye", 13)
    --vetor do olho s sua propriedades--
    currentLife = 1500
    
    AureaB = {}
    AureaB.posx = 80
    AureaB.posy = 105
    AureaB.img = love.graphics.newImage("imagens/Cruz/Blue_Aurea.png")
    AureaB.grid = anim8.newGrid(116, 99, AureaB.img:getWidth(), AureaB.img:getHeight())
    AureaB.anim = anim8.newAnimation(AureaB.grid('1-9',1), 0.20)

    eye = {}
    eye.posx = 120
    eye.posy = 165
    eye.img = love.graphics.newImage("imagens/Npcs/eyeball.png")
    eye.grid = anim8.newGrid(32, 32, eye.img:getWidth(), eye.img:getHeight())
    eye.anim = anim8.newAnimation(eye.grid('1-8',1, "1-8", 2, "1-8", 3), 0.08)
end


function points_update(dt)
    eye.anim:update(dt)
    AureaB.anim:update(dt)
    
    -- A SEGUIR TODOS OS PONTOS DE SPAWN DA AUREA DE PROTEÇÃO E VISÃO DO SEMELHANTE--
    
    --primeiro spawn--
    if px >= 100 and px <= 135 and py >= 170 and py <= 180  then
        eye.posx, eye.posy = 230, 310
        currentLife = 1000
        safe = true
    --segundo spawn--
    elseif px >= 230 and px <= 245  and py >= 310 and py <= 325 then
        eye.posx, eye.posy = 25, 505
        AureaB.posx, AureaB.posy = 185, 245
        currentLife = 1000
        safe = true
    --terceiro spawn--
    elseif px >= 10 and px <= 40  and py >= 510 and py <= 520 then
        eye.posx, eye.posy = 285, 525
        AureaB.posx, AureaB.posy = -15, 440
        currentLife = 1000
        safe = true
    --quarto spawn--
    elseif px >= 270 and px <= 300 and py >= 540 and py <= 550 then
        eye.posx, eye.posy = 485, 535
        AureaB.posx, AureaB.posy = 240, 469
        currentLife = 1000
        safe = true
       
    --quinto spawn-- 
    elseif px >= 470 and px <= 510 and py >= 540 and py <= 550 then
        eye.posx, eye.posy = 630, 190
        AureaB.posx, AureaB.posy = 450, 470
        currentLife = 1000
        safe = true
    --sexto spawn--
    elseif px >= 595 and px <= 635 and py >= 185 and py <= 205 then
        eye.posx, eye.posy = 500, 158
        AureaB.posx, AureaB.posy = 585, 115
        currentLife = 1000
        safe = true
        --sétimo spawn--
    elseif px >= 500 and px <= 520 and py >= 155 and py <= 165 then
        eye.posx, eye.posy = 800, 800 -- vai para fora do mapa
        currentLife = 1000
        AureaB.posx, AureaB.posy = 460, 85
        safe = true
    else
        currentLife = currentLife - 1
        safe = false
    end

    --nerf de velociade no terceiro andar do mapa--
    if px >= 75 and px <= 500 and py >= 520 and py <= 550 then
        forceR = 105
        forceL = - 105
        nerf = true
       
    else 
        forceR = 130
        forceL = - 130
        nerf = false
    end
end

function points_draw()
    eye.anim:draw(eye.img, eye.posx , eye.posy, 0, 1, 1, 12, 0)
    love.graphics.print("Sua quantidade de discernimento é : " .. currentLife)
    if nerf then
        love.graphics.print("As trevas te seguram...", 0, 400)
    else
        love.graphics.print("Corra!", 0, 400)
    end
    
    if safe then
        AureaB.anim:draw(AureaB.img, AureaB.posx, AureaB.posy, 0, 1 , 1, 12, 0)
    end

end
