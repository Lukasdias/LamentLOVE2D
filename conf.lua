local function loadConfig()
	local ok, cfg = pcall(require, "modules.config")
	if ok then
		return cfg
	end
	return nil
end

function love.conf(t)
	local cfg = loadConfig()
	local w = cfg and cfg.window or {}

	t.window.fullscreentype = w.fullscreentype or "desktop"
	t.window.width = w.width or 770
	t.window.height = w.height or 580
	t.window.title = w.title or "The Lament of Laurence"
	t.window.vsync = w.vsync or 1
	t.window.msaa = w.msaa or 0
	t.window.resizable = w.resizable or false
	t.window.highdpi = w.highdpi ~= false
	if w.icon and love.filesystem.getInfo(w.icon) then
		t.window.icon = w.icon
	end

	t.modules.physics = true
end
