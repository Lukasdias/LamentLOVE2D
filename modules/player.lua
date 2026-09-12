local anim8 = require('libs/anim8')
local config = require('modules.config')
local Camera = require('modules.camera')
local Afterimage = require('modules.afterimage')

local CFG = {
	MAX_SPEED = config.player.maxSpeed,
	GROUND_ACCEL = config.player.groundAccel,
	GROUND_DECEL = config.player.groundDecel,
	AIR_ACCEL = config.player.airAccel,
	AIR_DRAG = config.player.airDrag,
	GRAVITY = config.player.gravity,
	FALL_GRAVITY = config.player.fallGravity,
	APEX_GRAVITY = config.player.apexGravity,
	APEX_THRESHOLD = config.player.apexThreshold,
	MAX_FALL = config.player.maxFall,
	JUMP_SPEED = config.player.jumpSpeed,
	JUMP_CUT = config.player.jumpCut,
	COYOTE = config.player.coyote,
	JUMP_BUFFER = config.player.jumpBuffer,
	RUN_FPS = config.player.runFps,
	STOP_FPS = config.player.stopFps,
	JUMP_FPS = config.player.jumpFps,
	RUN_ANIM_THRESHOLD = config.player.runAnimThreshold,
	SPRITE_OFFSET_Y = config.player.spriteOffsetY,
	ORIGIN_X = config.player.originX,
}

laurence = {}

local facing = 1
local state = "stop"
local vy = 0
local jumpHeld = false
local jumpBufferTimer = 0
local coyoteTimer = 0
local trail

local function moveToward(v, target, delta)
	if v < target then
		return math.min(v + delta, target)
	end
	return math.max(v - delta, target)
end

local function isGrounded()
	local body = laurence.body
	for _, contact in ipairs(body:getContacts()) do
		local fA = contact:getFixtures()
		local nx, ny = contact:getNormal()
		if fA:getBody() == body then
			nx, ny = -nx, -ny
		end
		if ny < -0.7 then
			return true
		end
	end
	return false
end

local function currentAnim()
	if state == "jump" then
		return laurence.animJump, laurence.imgJump
	elseif state == "run" then
		return laurence.animRun, laurence.imgRun
	end
	return laurence.animStop, laurence.imgStop
end

function playerLoad(map, world)
	camera = Camera.new(config.camera)
	if map then
		camera:setBounds(0, 0, map.width * map.tilewidth, map.height * map.tileheight)
	end

	trail = Afterimage.new(config.afterimage)

	laurence.x = 20
	laurence.y = 30
	laurence.w = 22.5
	laurence.h = 22
	laurence.body = love.physics.newBody(world, config.player.spawnX, config.player.spawnY, "dynamic")
	laurence.shape = love.physics.newRectangleShape(20, 24.5)
	laurence.fixture = love.physics.newFixture(laurence.body, laurence.shape, 0.8)
	laurence.body:setFixedRotation(true)
	laurence.body:setGravityScale(0)

	laurence.imgStop = love.graphics.newImage("imagens/Cruz/Cruz_Stop.png")
	laurence.imgRun = love.graphics.newImage("imagens/Cruz/Cruz_Run.png")
	laurence.imgJump = love.graphics.newImage("imagens/Cruz/Cruz_Jump.png")

	laurence.gridStop = anim8.newGrid(21, 37, laurence.imgStop:getWidth(), laurence.imgStop:getHeight())
	laurence.gridRun = anim8.newGrid(34, 40, laurence.imgRun:getWidth(), laurence.imgRun:getHeight())
	laurence.gridJump = anim8.newGrid(33, 38, laurence.imgJump:getWidth(), laurence.imgJump:getHeight())

	laurence.animStop = anim8.newAnimation(laurence.gridStop('1-4', 1), CFG.STOP_FPS)
	laurence.animRun = anim8.newAnimation(laurence.gridRun('1-17', 1), CFG.RUN_FPS)
	laurence.animJump = anim8.newAnimation(laurence.gridJump('1-7', 1), CFG.JUMP_FPS, function(a)
		a:pauseAtEnd()
	end)

	facing = 1
	state = "stop"
	vy = 0
	jumpHeld = false
	jumpBufferTimer = 0
	coyoteTimer = 0

	camera:snap(laurence.body:getX(), laurence.body:getY())
end

function playerUpdate(dt)
	camera:update(dt)

	laurence.animStop:update(dt)
	laurence.animRun:update(dt)
	laurence.animJump:update(dt)

	laurence.x = laurence.body:getX()
	laurence.y = laurence.body:getY()
	camera:follow(laurence.x, laurence.y)

	isAlive()
	isEnded()
	hitPlayer()
	playerMove(dt)
	trail:update(dt)
end

function playerMove(dt)
	local body = laurence.body
	local onGround = isGrounded()

	if jumpBufferTimer > 0 then
		jumpBufferTimer = jumpBufferTimer - dt
	end

	if onGround and vy >= 0 then
		coyoteTimer = CFG.COYOTE
	elseif coyoteTimer > 0 then
		coyoteTimer = coyoteTimer - dt
	end

	local leftDown = love.keyboard.isDown("left")
	local rightDown = love.keyboard.isDown("right")
	local dir = 0
	if leftDown and not rightDown then
		dir = -1
	elseif rightDown and not leftDown then
		dir = 1
	end
	if dir ~= 0 then
		facing = dir
	end

	if jumpBufferTimer > 0 and coyoteTimer > 0 then
		vy = CFG.JUMP_SPEED
		jumpBufferTimer = 0
		coyoteTimer = 0
		laurence.animJump:gotoFrame(1)
		laurence.animJump:resume()
	end

	local vx = body:getLinearVelocity()

	local accel
	if dir ~= 0 then
		accel = onGround and CFG.GROUND_ACCEL or CFG.AIR_ACCEL
	else
		accel = onGround and CFG.GROUND_DECEL or CFG.AIR_DRAG
	end
	vx = moveToward(vx, dir * CFG.MAX_SPEED, accel * dt)

	local gravity
	if vy < 0 then
		if math.abs(vy) < CFG.APEX_THRESHOLD and jumpHeld then
			gravity = CFG.APEX_GRAVITY
		else
			gravity = CFG.GRAVITY
		end
	else
		gravity = CFG.FALL_GRAVITY
	end
	vy = vy + gravity * dt
	if vy > CFG.MAX_FALL then
		vy = CFG.MAX_FALL
	end
	if onGround and vy > 0 then
		vy = 0
	end

	body:setLinearVelocity(vx, vy)

	if not onGround then
		state = "jump"
	elseif math.abs(vx) > CFG.RUN_ANIM_THRESHOLD then
		state = "run"
	else
		state = "stop"
	end

	local emitting = (state == "run") or (not onGround)
	if emitting then
		local anim, img = currentAnim()
		trail:emit(anim, img, body:getX(), body:getY() + CFG.SPRITE_OFFSET_Y, facing, CFG.ORIGIN_X, dt)
	else
		trail:idle()
	end
end

function playerDraw()
	trail:draw()

	local x = laurence.body:getX()
	local y = laurence.body:getY() + CFG.SPRITE_OFFSET_Y
	local anim, img = currentAnim()
	anim:draw(img, x, y, 0, facing, 1, CFG.ORIGIN_X, 0)
end

function playerJump(key)
	if key == "space" or key == "up" then
		jumpHeld = true
		jumpBufferTimer = CFG.JUMP_BUFFER
	end
end

function lastKey(key)
	if key == "space" or key == "up" then
		jumpHeld = false
		if vy < 0 then
			vy = vy * CFG.JUMP_CUT
		end
	end
end

function isAlive()
	if currentLife <= 0 then
		gamestate = "death"
	end
end

function isEnded()
	local px, py = laurence.body:getPosition()
	if px >= 400 and px <= 460 and py >= 110 and py <= 175 then
		gamestate = "end"
	end
end

function hitPlayer()
	local px, py = laurence.body:getPosition()
	if (px >= npc.mummy.posx - 25) and (px <= npc.mummy.posx + 25) and (py <= 550) and (py >= 505) then
		laurence.body:applyForce(-10000, 0)
		currentLife = currentLife - 140
	end
end
