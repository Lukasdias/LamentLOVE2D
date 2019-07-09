local anim8 = require("libs/anim8")

function npcLoad(map)
   ghostLayer = map:addCustomLayer("ghost", 11)
   medusaLayer = map:addCustomLayer("medusa", 12)
   --vetor dos npcs--
   npc = {}
   --vetor do fantasma com efeitos azul e que está a esquerda--
   npc.ghost = {}
   npc.ghost.img = love.graphics.newImage('imagens/Npcs/ghost_blue.png')
   npc.ghost.grid= anim8.newGrid(37, 65 ,npc.ghost.img:getWidth() ,  npc.ghost.img:getHeight())
   npc.ghost.anim = anim8.newAnimation(npc.ghost.grid('1-4', 1) , 0.09)
   -- posições fantasma 1--
   npc.ghost.posx  = 10
   npc.ghost.posy = 25
   npc.ghost.vL = 1  
   --vetor do fantasma sem efeitos e que está a direita--
   npc.ghost2 = {}
   npc.ghost2.img = love.graphics.newImage('imagens/Npcs/ghost.png')
   npc.ghost2.grid= anim8.newGrid(37, 65 ,npc.ghost2.img:getWidth() ,  npc.ghost2.img:getHeight())
   npc.ghost2.anim = anim8.newAnimation(npc.ghost2.grid('1-4', 1) , 0.09)
    --posições fantasma 2--
   npc.ghost2.posx  = 300
   npc.ghost2.posy = 25
   npc.ghost2.vL = 1
   --Medusa do terceiro andar--
   npc.medusa = {}
   npc.medusa.img = love.graphics.newImage('imagens/Npcs/Medusa.png')
   npc.medusa.grid= anim8.newGrid(57, 88 ,npc.medusa.img:getWidth(),  npc.medusa.img:getHeight())
   npc.medusa.anim = anim8.newAnimation(npc.medusa.grid("1-8", 1), 0.09)
   --posições medusa--
   npc.medusa.posx = 205
   npc.medusa.posy = 400
   npc.medusa.vL = 0.5
    --Múmia do terceiro andar--
   npc.mummy = {}
   npc.mummy.img = love.graphics.newImage('imagens/Npcs/mummy.png')
   npc.mummy.grid= anim8.newGrid(37, 45 ,npc.mummy.img:getWidth(),  npc.mummy.img:getHeight())
   npc.mummy.anim = anim8.newAnimation(npc.mummy.grid("1-5", 1, "1-5", 2, "1-5", 3, "1-3", 4), 0.08)
    --poisição mumia---
   npc.mummy.posx  = 120
   npc.mummy.posy = 516
   npc.mummy.vL = 1
end

function npcUpdate(dt)
    npc.ghost.anim:update(dt)
    npc.ghost2.anim:update(dt)
    npc.medusa.anim:update(dt)
    npc.mummy.anim:update(dt)
    --movimentção do fantasma 1 e 2 no primeiro setor do mapa--
    if npc.ghost.posx >= 300 and npc.ghost2.posx >= 600 then
        npc.ghost.direcao = false
        npc.ghost2.direcao = false
        sent = true
    --configuração para a existencia do loop--
    elseif npc.ghost.posx <= 10 and npc.ghost2.posx <= 300 then 
        npc.ghost.direcao = true 
        npc.ghost2.direcao = true 
        sent = false
    end
    --movimentação da medusa no 3 andar--
    if npc.medusa.posx >= 450 then
        npc.medusa.direcao = false
        sent2 = true
    elseif npc.medusa.posx <= 200 then
        npc.medusa.direcao = true
        sent2 = false 
    end
    --condição para a imagem inverter a direcao--
    if npc.mummy.posx >= 500 then
        npc.mummy.direcao = false
        sent3 = true
    elseif npc.mummy.posx <= 125 then
        npc.mummy.direcao = true
        sent3 = false
    end
    --fantasmas irem para a direita ou esquerda--
    if npc.ghost.direcao then
        npc.ghost.posx = npc.ghost.posx + npc.ghost.vL --incrementa em x--
        npc.ghost2.posx = npc.ghost2.posx + npc.ghost2.vL -- incrementa em x--
    elseif not npc.ghost.direcao then
        npc.ghost.posx = npc.ghost.posx - npc.ghost.vL -- decrementa em x--
        npc.ghost2.posx = npc.ghost2.posx - npc.ghost2.vL -- decrementa em x--
    end
    --medusa ir para a direita ou esquerda
    if npc.medusa.direcao then
        npc.medusa.posx = npc.medusa.posx + npc.medusa.vL
    elseif not npc.medusa.direcao then
        npc.medusa.posx = npc.medusa.posx - npc.medusa.vL
    end
     --Múmia ir para direita e esquerda--
     if npc.mummy.direcao then
        npc.mummy.posx = npc.mummy.posx + npc.mummy.vL
    elseif not npc.mummy.direcao then
        npc.mummy.posx = npc.mummy.posx - npc.mummy.vL
    end
end

function npcDraw()
       -- desenhar os fantasmas no angulo e direção correta--
        if sent  then
            npc.ghost.anim:draw(npc.ghost.img, npc.ghost.posx, npc.ghost.posy, 0 , -1, 1, 12 , 0)
            npc.ghost2.anim:draw(npc.ghost2.img, npc.ghost2.posx, npc.ghost2.posy, 0 , -1, 1, 12 , 0)
        elseif not sent then
            npc.ghost.anim:draw(npc.ghost.img, npc.ghost.posx, npc.ghost.posy, 0 , 1, 1, 12 , 0)
            npc.ghost2.anim:draw(npc.ghost2.img, npc.ghost2.posx, npc.ghost2.posy, 0 , 1, 1, 12 , 0)
        end
        --desenhar a medusa com o angulo correto e no lugar correto--
        if sent2  then
             npc.medusa.anim:draw(npc.medusa.img, npc.medusa.posx, npc.medusa.posy, 0 , -1, 1, 24, 0)
        elseif not sent2 then
            npc.medusa.anim:draw(npc.medusa.img, npc.medusa.posx, npc.medusa.posy, 0 , 1, 1, 24, 0)
        end
        --desenhar a múmia com o angulo correto, lugar certo e direção correta--
        if sent3 then
            npc.mummy.anim:draw(npc.mummy.img, npc.mummy.posx, npc.mummy.posy, 0 , -1, 1, 13, 0)
        elseif not sent3 then
            npc.mummy.anim:draw(npc.mummy.img, npc.mummy.posx, npc.mummy.posy, 0 , 1, 1, 13, 0)
        end
end