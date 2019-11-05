--requires--
local anim8 = require ('libs/anim8')
local cam = require('STALKER-X/Camera')
--requires-- 
local cAnim
local cImg
local direcao 
laurence = {}

function playerLoad(map, world)
	--Criando a câmera--
	camera = cam()
	camera.scale = 2
	camera:setFollowStyle('PLATFORMER')
	
	--Criando o corpo do laurence e declarando suas propriedades--
	laurence.x = 20
	laurence.y = 30
	laurence.w = 22.5
	laurence.h = 22
	laurence.speed = 120
	laurence.jump = -30
	laurence.body = love.physics.newBody(world, 60, 120, "dynamic");
	laurence.shape = love.physics.newRectangleShape(20, 24.5);
	laurence.fixture = love.physics.newFixture(laurence.body, laurence.shape, 0.8)
	laurence.body:setFixedRotation(true)
	-- Sprites Organizados--
	--Imagens--
	laurence.imgStop = love.graphics.newImage("imagens/Cruz/Cruz_Stop.png")
	laurence.imgRun = love.graphics.newImage("imagens/Cruz/Cruz_Run.png")
	laurence.imgJump = love.graphics.newImage("imagens/Cruz/Cruz_Jump.png")
	--Grids--
	laurence.gridStop = anim8.newGrid(21, 37,laurence.imgStop:getWidth(), laurence.imgStop:getHeight())
	laurence.gridRun= anim8.newGrid(34, 40,laurence.imgRun:getWidth(), laurence.imgRun:getHeight())
	laurence.gridJump = anim8.newGrid(33, 38,laurence.imgJump:getWidth(), laurence.imgJump:getHeight())
	--Animações--
	laurence.animStop = anim8.newAnimation(laurence.gridStop('1-4',1), 0.08)
	laurence.animRun = anim8.newAnimation(laurence.gridRun('1-17',1), 0.08)
	laurence.animJump = anim8.newAnimation(laurence.gridJump('1-7',1), 0.08)
end

function playerUpdate(dt)
	--Atualizandoa  câmera--
	camera:update(dt)
	camera:follow(laurence.body:getX(), laurence.body:getY())
	--atualizar animação--
	laurence.animStop:update(dt)
	laurence.animRun:update(dt)
	laurence.animJump:update(dt)
	--posição do corpo--
	laurence.x = laurence.body:getX()
	laurence.y = laurence.body:getY()
	--Fazendo a camera acompanhar o player--
	camera:follow(laurence.x, laurence.y)
	isAlive()
	isEnded()
	hitPlayer()
	playerMove(dt)

end

function isAlive()
	--condição para dar Game Over--
	if currentLife <= 0 then
		gamestate = "death"
	end
end

function isEnded()
	local px, py = laurence.body:getPosition()
	if px >=400 and px <= 460 and py >=110 and py <=175 then
		gamestate = "end"
	end
end

function hitPlayer()
	local px, py = laurence.body:getPosition()
	-- se o jogador estiver perto da múmia então tomara um impulso para a esquerda e recebera dano --
	if (px >= npc.mummy.posx - 25) and (px <= npc.mummy.posx + 25) and (py <= 550) and (py >= 505) then
		laurence.body:applyForce(-10000, 0)
		currentLife = currentLife - 140
	end
end

function playerDraw()
	if cAnim == laurence.animRun  then
		if direcao  then
			laurence.animRun:draw(laurence.imgRun, laurence.body:getX(), laurence.body:getY()-19, 0 , 1 , 1 , 12 , 0)
		elseif not direcao then
			laurence.animRun:draw(laurence.imgRun, laurence.body:getX() , laurence.body:getY()-19, 0 , -1 , 1 , 12, 0)
		end	
	elseif cAnim == laurence.animStop then
			if left == true then
				laurence.animStop:draw(laurence.imgStop, laurence.body:getX(), laurence.body:getY()-19,0 , -1 , 1 , 12 , 0)
			elseif right == true then
				laurence.animStop:draw(laurence.imgStop , laurence.body:getX() , laurence.body:getY()-19,0 , 1 , 1 , 12 , 0)
			else
				laurence.animStop:draw(laurence.imgStop, laurence.body:getX() , laurence.body:getY()-19, 0 , 1 , 1 , 12 , 0)
			end
	elseif cAnim == laurence.animJump then
		if direcao then
			laurence.animJump:draw(laurence.imgJump, laurence.body:getX(), laurence.body:getY()-19, 0 , 1 , 1 , 12 , 0)
		elseif not direcao then
			laurence.animJump:draw(laurence.imgJump, laurence.body:getX(), laurence.body:getY()-19, 0 , -1 , 1 , 12 , 0)
		end
	end
end

function playerMove(dt)
	--movimentação do personagem--
	if love.keyboard.isDown("right")  then 
		cAnim = laurence.animRun
		cImg = laurence.imgRun
		laurence.body:applyLinearImpulse(5, 5)
		direcao = true
	elseif love.keyboard.isDown("left") then
		cAnim = laurence.animRun
		cImg = laurence.imgRun
		laurence.body:applyLinearImpulse(-5, 5)
		direcao = false
	elseif left == true then
		cAnim = laurence.animStop
		cImg = laurence.imgStop
	elseif right == true then
		cAnim = laurence.animStop
		cImg = laurence.imgStop
	end
end

function playerJump(key)
	n = world:getContactCount()
	if((key == "space" or key == "up") and n>0) then
		altura = laurence.body:getY()
		aux = altura
		cAnim = laurence.animJump
		cImg = laurence.imgJump
		laurence.body:applyLinearImpulse(0, -32)
		if(aux>altura + 35) then
			laurence.body:applyLinearImpulse(0, 32)
		end
	end
end

function lastKey(key)
	if key == "left" then
		left = true 
		right = false		
	elseif key == "right" then
		left = false
		right = true
	elseif key == "up" then
		laurence.altura = 0
		cAnim = laurence.animJump
		cImg = laurence.imgJump
	end
	--inercia 0--
	if key == "left" or "right" or "up" then
		laurence.body:setLinearVelocity(0, 1)
	end
end	

