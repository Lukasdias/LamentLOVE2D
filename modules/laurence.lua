--requires--
local anim8 = require ('libs/anim8')

local animationAtual

local imagemAtual

local direcao 

  function Laurence_load(map, world)
	--força para a esquerda--
	forceL = -100
	--força para a direita--
	forceR = 100
	--força para cima
	forceJ = -900
	--Criando o corpo do laurence e declarando suas propriedades--
	laurence = {}
	laurence.speed = 100 
	laurence.velocity = 0
	laurence.VLY = 0
	laurence.body = love.physics.newBody(world, 60, 120, "dynamic")
	laurence.shape = love.physics.newRectangleShape(27.5, 25.5)
	laurence.body:setMass(7000); 
	laurence.fixture = love.physics.newFixture(laurence.body, laurence.shape)
	-- Sprites Organizados--
	laurenceImg = {}
	laurenceImg.Stop = love.graphics.newImage("imagens/Cruz/Cruz_Stop.png")
	laurenceImg.Run = love.graphics.newImage("imagens/Cruz/Cruz_Run.png")
	laurenceImg.Jump = love.graphics.newImage("imagens/Cruz/Cruz_Jump.png")
	--Grids--
	laurenceGrids = {}
	laurenceGrids.gridStop = anim8.newGrid(21, 37,laurenceImg.Stop:getWidth(), laurenceImg.Stop:getHeight())
	laurenceGrids.gridRun= anim8.newGrid(34, 40,laurenceImg.Run:getWidth(), laurenceImg.Run:getHeight())
	laurenceGrids.gridJump = anim8.newGrid(33, 38,laurenceImg.Jump:getWidth(), laurenceImg.Jump:getHeight())
	--Animações--
	laurenceAnim = {}
	laurenceAnim.Stop = anim8.newAnimation(laurenceGrids.gridStop('1-4',1), 0.08)
	laurenceAnim.Run = anim8.newAnimation(laurenceGrids.gridRun('1-17',1), 0.08)
	laurenceAnim.Jump = anim8.newAnimation(laurenceGrids.gridJump('1-7',1), 0.08)
end

function Laurence_update(dt)
	--posição do corpo--
	--print(laurence.VLY)
	px = math.floor(laurence.body:getX())
	py = math.floor(laurence.body:getY())
	--------------------------------------------------
    --------------------------------------------------
	--condição para dar Game Over--
	if currentLife <= 0 then
		gamestate = "Game Over"
	end

	if px >=400 and px <= 460 and py >=110 and py <=175 then
		gamestate = "Ending"
	end
---------------------------------------------------------------------------
	--Animação parado--
	laurenceAnim.Stop:update(dt)
	laurenceAnim.Run:update(dt)
	laurenceAnim.Jump:update(dt)
	-- se o jogador estiver perto da múmia então tomara um impulso para a esquerda e recebera dano --
	if (px >= npc.mummy.posx - 25) and (px <= npc.mummy.posx + 25) and (py <= 550) and (py >= 505) then
		laurence.body:applyForce(-10000, 0)
		currentLife = currentLife - 140
	end
	--movimentação do personagem--
	if love.keyboard.isDown("right")  then 
		animationAtual = laurenceAnim.Run
		imagemAtual = laurenceImg.Run
		laurence.body:applyForce( forceR, 0)
		direcao = true
	elseif love.keyboard.isDown("left") then
		animationAtual = laurenceAnim.Run
		imagemAtual = laurenceImg.Run
		laurence.body:applyForce( forceL, 0 )
		direcao = false
	--configuração do pulo--
	elseif love.keyboard.isDown("up") then
		animationAtual = laurenceAnim.Jump
		imagemAtual = laurenceImg.Jump
		laurence.body:applyForce(0, -450 ) --aplica força para cima--
		laurence.VLY = laurence.VLY + 10 -- incrementa em um cont--
			if laurence.VLY >= 150 then -- quando chegar proximo a 200 aplica-se um força na direção contraria
				laurence.body:applyForce(0, 900)--força ja citada sendo aplicada
				laurenceAnim.Jump:pauseAtEnd()--pausar a animação de pulo em seu ultimo frame
			end
	elseif left == true then
		animationAtual = laurenceAnim.Stop
		imagemAtual = laurenceImg.Stop
	elseif right == true then
		animationAtual = laurenceAnim.Stop
		imagemAtual = laurenceImg.Stop
	else
		animationAtual = laurenceAnim.Stop
		imagemAtual = laurenceImg.Stop
	end

end
-- checa para qual direção ele deve ficar apontado--
function last_keyreleased(key)
	if key == "left" then
		left = true 
		right = false		
	elseif key == "right" then
		left = false
		right = true
	elseif key == "up" then
		laurence.VLY = 0
		animationAtual = laurenceAnim.Jump
		imagemAtual = laurenceImg.Jump
	end
	--inercia 0--
	if key == "left" or "right" or "up" then
		laurence.body:setLinearVelocity(0, 1)
	end
end

function Laurence_draw()
	--love.graphics.setColor(255, 0.18, 0.05)
	--love.graphics.polygon("fill", laurence.body:getWorldPoints(laurence.shape:getPoints()))
-------------------------------------------------------------------------------------------------------------------
	--desenha a animação correspondente--
	if animationAtual == laurenceAnim.Run  then
		if direcao  then
			laurenceAnim.Run:draw(laurenceImg.Run, laurence.body:getX(), laurence.body:getY()-19, 0 , 1 , 1 , 12 , 0)
		elseif not direcao then
			laurenceAnim.Run:draw(laurenceImg.Run, laurence.body:getX() , laurence.body:getY()-19, 0 , -1 , 1 , 12, 0)
		end	
	--desenha o laurence parado para o lado certo
	elseif animationAtual == laurenceAnim.Stop then
			if left == true then
				laurenceAnim.Stop:draw(laurenceImg.Stop, laurence.body:getX(), laurence.body:getY()-19,0 , -1 , 1 , 12 , 0)
			elseif right == true then
				laurenceAnim.Stop:draw(laurenceImg.Stop , laurence.body:getX() , laurence.body:getY()-19,0 , 1 , 1 , 12 , 0)
			else
				laurenceAnim.Stop:draw(laurenceImg.Stop, laurence.body:getX() , laurence.body:getY()-19, 0 , 1 , 1 , 12 , 0)
			end
--------------------------------------------------------------------------------------------------------------------------------			
	elseif animationAtual == laurenceAnim.Jump then
		if direcao then
			laurenceAnim.Jump:draw(laurenceImg.Jump, laurence.body:getX(), laurence.body:getY()-19, 0 , 1 , 1 , 12 , 0)
		elseif not direcao then
			laurenceAnim.Jump:draw(laurenceImg.Jump, laurence.body:getX(), laurence.body:getY()-19, 0 , -1 , 1 , 12 , 0)
		end
	end
end


	

