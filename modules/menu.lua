local config = require("modules.config")
local Background = require("modules.menu_background")
local Button = require("modules.ui_button")

local background
local buttons = {}
local selected = 1
local font

local function startGame()
	play = true
end

local function quitGame()
	love.event.quit()
end

local function layout()
	local bc = config.menu.button
	local W = love.graphics.getWidth()
	local totalH = #buttons * bc.height + (#buttons - 1) * bc.spacing
	local startY = bc.startY
	if startY + totalH > love.graphics.getHeight() - 8 then
		startY = (love.graphics.getHeight() - totalH) / 2
	end
	for i, b in ipairs(buttons) do
		b.w = bc.width
		b.h = bc.height
		b.x = (W - bc.width) / 2
		b.y = startY + (i - 1) * (bc.height + bc.spacing)
	end
end

local function refreshFocus()
	for i, b in ipairs(buttons) do
		b.focused = (i == selected)
	end
end

function menuLoad()
	gamestate = "menu"
	selected = 1

	font = love.graphics.newFont(config.menu.button.fontSize)
	background = Background.new(config.menu)

	local colors = config.menu.button
	buttons = {
		Button.new({
			label = config.menu.labels.start,
			w = colors.width,
			h = colors.height,
			font = font,
			colors = colors,
			onClick = startGame,
		}),
		Button.new({
			label = config.menu.labels.quit,
			w = colors.width,
			h = colors.height,
			font = font,
			colors = colors,
			onClick = quitGame,
		}),
	}
	layout()
	refreshFocus()
end

function menuUpdate(dt)
	background:update(dt)
	for _, b in ipairs(buttons) do
		b:update(dt)
	end
	if play and gamestate == "menu" then
		gamestate = "play"
	end
end

function menuDraw()
	background:draw()
	for _, b in ipairs(buttons) do
		b:draw()
	end
	love.graphics.setColor(1, 1, 1, 1)
end

function menuMousemoved(x, y)
	for _, b in ipairs(buttons) do
		b:setHover(x, y)
	end
end

function menuMousepressed(x, y, button)
	if button == 1 then
		for _, b in ipairs(buttons) do
			b:mousepressed(x, y, button)
		end
	end
end

function menuKeypressed(key)
	if key == "up" or key == "w" then
		selected = selected - 1
		if selected < 1 then
			selected = #buttons
		end
		refreshFocus()
	elseif key == "down" or key == "s" then
		selected = selected + 1
		if selected > #buttons then
			selected = 1
		end
		refreshFocus()
	elseif key == "return" or key == "kpenter" or key == "space" then
		buttons[selected]:activate()
	end
end

function menuSnapshot()
	return {
		selected = selected,
		buttons = buttons,
		background = background,
	}
end
