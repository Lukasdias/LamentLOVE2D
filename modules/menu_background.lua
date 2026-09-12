local anim8 = require("libs/anim8")

local Background = {}
Background.__index = Background

local function frameArgs(cols, rows)
	local args = {}
	for r = 1, rows do
		args[#args + 1] = "1-" .. cols
		args[#args + 1] = r
	end
	return args
end

function Background.new(cfg)
	local self = setmetatable({}, Background)

	local bgCfg = cfg.background
	self.bgImg = love.graphics.newImage(bgCfg.path)
	self.bgGrid = anim8.newGrid(bgCfg.frameW, bgCfg.frameH, self.bgImg:getWidth(), self.bgImg:getHeight())
	self.bgAnim = anim8.newAnimation(self.bgGrid(unpack(frameArgs(bgCfg.cols, bgCfg.rows))), bgCfg.fps)
	self.bgScale = math.max(
		love.graphics.getWidth() / bgCfg.frameW,
		love.graphics.getHeight() / bgCfg.frameH
	)

	local titleCfg = cfg.title
	self.titleImg = love.graphics.newImage(titleCfg.path)
	self.titleGrid = anim8.newGrid(titleCfg.frameW, titleCfg.frameH, self.titleImg:getWidth(), self.titleImg:getHeight())
	local titleArgs = {}
	for r = 1, titleCfg.count do
		titleArgs[#titleArgs + 1] = 1
		titleArgs[#titleArgs + 1] = r
	end
	self.titleAnim = anim8.newAnimation(self.titleGrid(unpack(titleArgs)), titleCfg.fps)
	self.titleY = titleCfg.y
	self.titleScale = titleCfg.scale or 1

	local creditsCfg = cfg.credits
	self.creditsImg = love.graphics.newImage(creditsCfg.path)
	self.creditsY = creditsCfg.y
	self.creditsScale = creditsCfg.scale or 1
	self.creditsAlpha = creditsCfg.alpha or 1

	self.overlay = cfg.overlay or 0

	return self
end

function Background:update(dt)
	self.bgAnim:update(dt)
	self.titleAnim:update(dt)
end

function Background:draw()
	local W, H = love.graphics.getWidth(), love.graphics.getHeight()

	local bgW = self.bgImg:getWidth() / self.bgGrid.frameWidth
	local bgH = self.bgImg:getHeight() / self.bgGrid.frameHeight
	local fw, fh = self.bgGrid.frameWidth, self.bgGrid.frameHeight

	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.draw(
		self.bgImg,
		(love.graphics.getWidth() - fw) / 2,
		(love.graphics.getHeight() - fh) / 2,
		0,
		self.bgScale,
		self.bgScale,
		fw / 2,
		fh / 2,
		0,
		0,
		0,
		fw,
		fh
	)

	if self.overlay > 0 then
		love.graphics.setColor(0, 0, 0, self.overlay)
		love.graphics.rectangle("fill", 0, 0, W, H)
	end

	local tw = self.titleGrid.frameWidth * self.titleScale
	local th = self.titleGrid.frameHeight * self.titleScale
	love.graphics.setColor(1, 1, 1, 1)
	self.titleAnim:draw(self.titleImg, (W - tw) / 2, self.titleY, 0, self.titleScale, self.titleScale)

	local cw = self.creditsImg:getWidth() * self.creditsScale
	love.graphics.setColor(1, 1, 1, self.creditsAlpha)
	love.graphics.draw(self.creditsImg, (W - cw) / 2, self.creditsY, 0, self.creditsScale, self.creditsScale)

	love.graphics.setColor(1, 1, 1, 1)
end

return Background
