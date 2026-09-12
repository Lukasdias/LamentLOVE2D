local config = require('modules.config')
local Camera = require('modules.camera')
local Afterimage = require('modules.afterimage')
local StateMachine = require('modules.anim_state_machine')
local PlayerAnims = require('modules.player_anims')

local CFG = config.player

laurence = {}

local facing = 1
local vy = 0
local jumpHeld = false
local jumpBufferTimer = 0
local coyoteTimer = 0
local trail
local machine
local sheet

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

local function currentRect()
	return machine:currentRect()
end

-- The sprite's feet are pinned to the bottom edge of the physics box, so every
-- animation stays planted regardless of its per-frame height. The box is centered
-- on the body origin, so its bottom sits at bodyY + boxHeight/2.
local function spriteTop(rect)
	return laurence.body:getY() + CFG.boxHeight / 2 - rect.h
end

function playerLoad(map, world)
	camera = Camera.new(config.camera)
	if map then
		camera:setBounds(0, 0, map.width * map.tilewidth, map.height * map.tileheight)
	end

	trail = Afterimage.new(config.afterimage)
	sheet, anims = PlayerAnims.load()

	machine = StateMachine.new()
	machine:add("idle", anims.idle)
	machine:add("walk", anims.walk)
	machine:add("run", anims.run)
	machine:add("dash", anims.dash)
	machine:add("jump", anims.jump, { interrupt = false })
	machine:add("fall", anims.fall)
	machine:add("hurt", anims.hurt, { interrupt = false })
	machine:transition("idle")

	laurence.x = 20
	laurence.y = 30
	laurence.w = 22.5
	laurence.h = 22
	laurence.body = love.physics.newBody(world, CFG.spawnX, CFG.spawnY, "dynamic")
	laurence.shape = love.physics.newRectangleShape(CFG.boxWidth, CFG.boxHeight)
	laurence.fixture = love.physics.newFixture(laurence.body, laurence.shape, 0.8)
	laurence.body:setFixedRotation(true)
	laurence.body:setGravityScale(0)

	facing = 1
	vy = 0
	jumpHeld = false
	jumpBufferTimer = 0
	coyoteTimer = 0

	camera:snap(laurence.body:getX(), laurence.body:getY())
end

function playerUpdate(dt)
	camera:update(dt)

	laurence.x = laurence.body:getX()
	laurence.y = laurence.body:getY()
	camera:follow(laurence.x, laurence.y)

	isAlive()
	isEnded()
	hitPlayer()
	playerMove(dt)
	machine:update(dt)
	trail:update(dt)
end

function playerMove(dt)
	local body = laurence.body
	local onGround = isGrounded()

	if jumpBufferTimer > 0 then
		jumpBufferTimer = jumpBufferTimer - dt
	end

	if onGround and vy >= 0 then
		coyoteTimer = CFG.coyote
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
		vy = CFG.jumpSpeed
		jumpBufferTimer = 0
		coyoteTimer = 0
		machine:transition("jump")
	end

	local vx = body:getLinearVelocity()

	local accel
	if dir ~= 0 then
		accel = onGround and CFG.groundAccel or CFG.airAccel
	else
		accel = onGround and CFG.groundDecel or CFG.airDrag
	end
	vx = moveToward(vx, dir * CFG.maxSpeed, accel * dt)

	local gravity
	if vy < 0 then
		if math.abs(vy) < CFG.apexThreshold and jumpHeld then
			gravity = CFG.apexGravity
		else
			gravity = CFG.gravity
		end
	else
		gravity = CFG.fallGravity
	end
	vy = vy + gravity * dt
	if vy > CFG.maxFall then
		vy = CFG.maxFall
	end
	if onGround and vy > 0 then
		vy = 0
	end

	body:setLinearVelocity(vx, vy)

	if not onGround then
		if vy < 0 then
			machine:transition("jump")
		else
			machine:transition("fall")
		end
	elseif math.abs(vx) > CFG.runAnimThreshold then
		machine:transition("run")
	else
		machine:transition("idle")
	end

	local inAir = not onGround
	local moving = math.abs(vx) > CFG.runAnimThreshold
	if inAir or moving then
		local rect = currentRect()
		trail:emit(sheet, rect, body:getX(), spriteTop(rect), facing, rect.w / 2, dt)
	else
		trail:idle()
	end
end

function playerDraw()
	trail:draw()

	local x = laurence.body:getX()
	local rect = currentRect()
	local y = spriteTop(rect)
	love.graphics.draw(sheet.image, sheet:quad(rect), x, y, 0, facing, 1, rect.w / 2, rect.h)
end

function playerJump(key)
	if key == "space" or key == "up" then
		jumpHeld = true
		jumpBufferTimer = CFG.jumpBuffer
	end
end

function playerSnapshot()
	return {
		sheet = sheet,
		machine = machine,
		trail = trail,
		facing = facing,
		vy = vy,
		body = laurence.body,
		state = machine and machine.current,
	}
end

function lastKey(key)
	if key == "space" or key == "up" then
		jumpHeld = false
		if vy < 0 then
			vy = vy * CFG.jumpCut
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
	local mummy = enemyManager and enemyManager:get("mummy")
	if not mummy then
		return
	end
	if (px >= mummy.x - 25) and (px <= mummy.x + 25) and (py <= 550) and (py >= 505) then
		laurence.body:applyForce(-10000, 0)
		currentLife = currentLife - 140
		machine:transition("hurt")
	end
end
