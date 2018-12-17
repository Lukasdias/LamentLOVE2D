--requires--
Camera = require ('libs/Camera')
local anim8 = require ('libs/anim8')
local animationAtual
local imagemAtual
local direcao 

  function Laurence_load(map, world)
	--------------------Configurações da Câmera--------------------------
	camera = Camera()
	camera.scale = 2
	camera:setFollowStyle('SCREEN_BY_SCREEN')
	--força para a esquerda--
	forceL = -10
	--força para a direita--
	forceR = 10
	--Criando o corpo do laurence e declarando suas propriedades--
	laurence = {}
	-- Sprites Organizados--
	laurenceImg = {}
	laurenceImg.Stop = love.graphics.newImage("imagens/Player/Alucard_Stop.png")
	laurenceImg.Run = love.graphics.newImage("imagens/Player/Alucard_Run.png")
	laurenceImg.Jump = love.graphics.newImage("imagens/Player/Alucard_Jump.png")
	laurenceImg.Duck = love.graphics.newImage("imagens/Player/Alucard_Duck.png")
	laurenceImg.Fall = love.graphics.newImage("imagens/Player/Alucard_Falling.png")
	--Grids--
	laurenceGrids = {}
	laurenceGrids.gridStop = anim8.newGrid(30, 54,laurenceImg.Stop:getWidth(), laurenceImg.Stop:getHeight())
	laurenceGrids.gridRun= anim8.newGrid(46, 55,laurenceImg.Run:getWidth(), laurenceImg.Run:getHeight())
	laurenceGrids.gridJump = anim8.newGrid(49, 53,laurenceImg.Jump:getWidth(), laurenceImg.Jump:getHeight())
	laurenceGrids.gridDuck = anim8.newGrid(50, 52,laurenceImg.Duck:getWidth(), laurenceImg.Duck:getHeight())
	laurenceGrids.gridFall = anim8.newGrid(51, 67,laurenceImg.Fall:getWidth(), laurenceImg.Fall:getHeight())
	--Animações--
	laurenceAnim = {}
	laurenceAnim.Stop = anim8.newAnimation(laurenceGrids.gridStop('1-6',1), 0.05)
	laurenceAnim.Run = anim8.newAnimation(laurenceGrids.gridRun('1-17',1), 0.05)
	laurenceAnim.Jump = anim8.newAnimation(laurenceGrids.gridJump('1-4',1), 0.05)
	laurenceAnim.Duck = anim8.newAnimation(laurenceGrids.gridDuck('1-15',1), 0.05)
	laurenceAnim.Fall = anim8.newAnimation(laurenceGrids.gridFall('1-2',1), 0.05)
	--Física--
	laurence.body = love.physics.newBody(world,20, 120, "dynamic")
	laurence.shape = love.physics.newRectangleShape(26, 35) 
	laurence.fixture = love.physics.newFixture(laurence.body, laurence.shape)
	laurence.body:setMassData(laurence.shape:computeMass(1))
	--Detectar colissões--
	laurence.fixture:setUserData("player")
	laurence.body:setFixedRotation(true)
	--contacts = world:getContactCount()
	laurence.body:setInertia(0)
end

function Laurence_update(dt)
	camera:update(dt)
	contacts = world:getContactCount()
	px = math.floor(laurence.body:getX())
	py = math.floor(laurence.body:getY())
	camera:follow(px, py)
	--condição para dar Game Over--
	if currentLife <= 0 then
		gamestate = "Game Over"
	end
	--condição para encerrar o jogo--
	if px >=400 and px <= 460 and py >=110 and py <=175 then
		gamestate = "Ending"
	end
---------------------------------------------------------------------------
	--Animação parado--
	laurenceAnim.Stop:update(dt)
	laurenceAnim.Run:update(dt)
	laurenceAnim.Jump:update(dt)
	laurenceAnim.Duck:update(dt)
	laurenceAnim.Fall:update(dt)
	--movimentação do personagem--
	if love.keyboard.isDown("right")  then
		animationAtual = laurenceAnim.Run
		imagemAtual = laurenceImg.Run
		laurence.body:applyForce(200, 0)
		direcao = true
	elseif love.keyboard.isDown("left") then
		animationAtual = laurenceAnim.Run
		imagemAtual = laurenceImg.Run
		laurence.body:applyForce(-200, 0)
		direcao = false
	elseif love.keyboard.isDown("down") then
		animationAtual = laurenceAnim.Duck
		imagemAtual = laurenceImg.Duck
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
	end
end

function jump_config(key)
	if key == "space" and contacts ~= 0  then
		laurence.body:applyLinearImpulse(0, -200)
		animationAtual = laurenceAnim.Jump
		imagemAtual = laurenceImg.Jump
		jump = true
	end
	
end


function Laurence_draw()
	--love.graphics.polygon("line", laurence.body:getWorldPoints(laurence.shape:getPoints()))-- Hitbox
-------------------------------------------------------------------------------------------------------------------
	--desenha a animação correspondente--
	if animationAtual == laurenceAnim.Run  then
		if direcao  then
			laurenceAnim.Run:draw(laurenceImg.Run, laurence.body:getX() - 10, laurence.body:getY() - 19, 0 , 1 , 0.7, 10, 0)
		elseif not direcao then 
			laurenceAnim.Run:draw(laurenceImg.Run, laurence.body:getX() + 10, laurence.body:getY() - 19, 0 , -1 , 0.7, 10, 0)
		end	
	--desenha o laurence parado para o lado certo
	elseif animationAtual == laurenceAnim.Stop then
			if left == true then
				laurenceAnim.Stop:draw(laurenceImg.Stop, laurence.body:getX()+8, laurence.body:getY() - 19, 0 , -1, 0.7, 10, 0)
			elseif right == true then
				laurenceAnim.Stop:draw(laurenceImg.Stop , laurence.body:getX()-5, laurence.body:getY() - 19, 0 , 1 , 0.7, 10, 0)
			else
				laurenceAnim.Stop:draw(laurenceImg.Stop, laurence.body:getX()-5, laurence.body:getY() - 19, 0 , 1 , 0.7, 10, 0)
			end
-----desenha animação de pulo-------------------------------------------------------------------------			
	elseif animationAtual == laurenceAnim.Jump then
		if direcao then
			laurenceAnim.Jump:draw(laurenceImg.Jump, laurence.body:getX()-5, laurence.body:getY() - 19, 0 , 1 , 0.7, 10, 0)
		elseif not direcao then
			laurenceAnim.Jump:draw(laurenceImg.Jump, laurence.body:getX()-5, laurence.body:getY() - 19, 0 , -1 , 0.7, 10, 0)
		end
	end
end
