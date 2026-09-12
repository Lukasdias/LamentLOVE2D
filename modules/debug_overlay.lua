local DebugOverlay = {}
DebugOverlay.__index = DebugOverlay

-- Draws the player's physics box next to the sprite so alignment is visible, and
-- logs sprite vs box metrics when the state changes. Toggle with F3.

local enabled = false
local lastState = nil
local lastRect = nil
local logging = true

local function metrics(snapshot)
	local rect = snapshot.machine:currentRect()
	if not rect then
		return nil
	end
	local cfg = require("modules.config")
	local body = snapshot.body
	local boxW, boxH = cfg.player.boxWidth, cfg.player.boxHeight
	local boxLeft = body:getX() - boxW / 2
	local boxTop = body:getY() - boxH / 2
	local boxBottom = body:getY() + boxH / 2
	local spriteTop = boxBottom - rect.h
	local feetGap = (spriteTop + rect.h) - boxBottom
	local widthGap = body:getX() + rect.w / 2 - (boxLeft + boxW)
	return {
		state = snapshot.state,
		rect = rect,
		box = { x = boxLeft, y = boxTop, w = boxW, h = boxH },
		sprite = { x = body:getX() - rect.w / 2, y = spriteTop, w = rect.w, h = rect.h },
		body = { x = body:getX(), y = body:getY() },
		feetGap = feetGap,
		widthGap = widthGap,
	}
end

function DebugOverlay.toggle()
	enabled = not enabled
	return enabled
end

function DebugOverlay.enable()
	enabled = true
	return enabled
end

function DebugOverlay.disable()
	enabled = false
	return enabled
end

function DebugOverlay.metrics(snapshot)
	return metrics(snapshot)
end

function DebugOverlay.isEnabled()
	return enabled
end

function DebugOverlay.update(snapshot)
	if not enabled or not snapshot then
		return
	end
	local m = metrics(snapshot)
	if not m then
		return
	end
	local rect = m.rect
	if lastState ~= m.state or lastRect ~= rect then
		lastState = m.state
		lastRect = rect
		print(string.format(
			"[align] %-8s sprite %dx%d  box %.1fx%.1f  feet_gap %+.1f  width_overhang %+.1f  body=(%.1f,%.1f)",
			m.state, rect.w, rect.h, m.box.w, m.box.h, m.feetGap, m.widthGap,
			m.body.x, m.body.y))
	end
end

function DebugOverlay.draw(snapshot)
	if not enabled or not snapshot then
		return
	end
	local m = metrics(snapshot)
	if not m then
		return
	end

	love.graphics.setColor(1, 1, 1, 1)
	local prevBlend = love.graphics.getBlendMode()
	love.graphics.setBlendMode("alpha")

	local outline = { 1, 0, 0, 0.9 }
	love.graphics.setColor(outline)
	love.graphics.setLineWidth(1)
	love.graphics.rectangle("line", m.box.x, m.box.y, m.box.w, m.box.h)

	local feetY = m.box.y + m.box.h
	love.graphics.setColor(0, 1, 1, 0.9)
	love.graphics.line(m.box.x - 6, feetY, m.box.x + m.box.w + 6, feetY)

	love.graphics.setColor(1, 1, 0, 0.9)
	love.graphics.rectangle("line", m.sprite.x, m.sprite.y, m.sprite.w, m.sprite.h)

	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.setBlendMode(prevBlend)
end

return DebugOverlay
