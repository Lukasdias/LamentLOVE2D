local Assets = {}

-- Cross-OS asset resolution.
--
-- This project was authored on Windows, where the filesystem is case-insensitive.
-- LÖVE on Linux/macOS is case-sensitive, so "imagens/menu/menuBG.png" fails when
-- the file on disk is "imagens/Menu/MenuBG.png". Backslashes from Windows paths
-- and a leading "./" also vary by authoring machine.
--
-- Assets.path normalizes the separator and resolves to the real on-disk casing
-- by consulting an index of love.filesystem, built once and cached. Call sites
-- keep using natural paths; a wrong-case or missing path raises a clear error at
-- load time instead of failing deep inside gameplay.

local index = nil
local cache = {}

local function normalize(path)
	local p = path:gsub("\\", "/")
	p = p:gsub("^%./", "")
	p = p:gsub("//+", "/")
	return p
end

local function buildIndex()
	index = {}
	local stack = { "" }
	while #stack > 0 do
		local dir = table.remove(stack)
		local items = love.filesystem.getDirectoryItems(dir)
		for _, name in ipairs(items) do
			if name ~= ".git" and name:sub(-16) ~= ":Zone.Identifier" then
				local full = dir == "" and name or (dir .. "/" .. name)
				local info = love.filesystem.getInfo(full)
				if info and info.type == "directory" then
					stack[#stack + 1] = full
				else
					index[full:lower()] = full
				end
			end
		end
	end
	return index
end

function Assets.refresh()
	index = nil
	cache = {}
	return Assets
end

local function lookup(path)
	if not index then
		buildIndex()
	end
	return index[path:lower()]
end

-- Returns the on-disk path for `path`, or nil plus a reason.
function Assets.resolve(path)
	local norm = normalize(path)
	local cached = cache[norm]
	if cached ~= nil then
		if cached == false then
			return nil, "not found"
		end
		return cached
	end
	local real = lookup(norm)
	if real then
		cache[norm] = real
		return real
	end
	cache[norm] = false
	return nil, "not found"
end

function Assets.exists(path)
	return Assets.resolve(path) ~= nil
end

-- Same as resolve but raises a descriptive error naming the requested path.
function Assets.path(path)
	local real, err = Assets.resolve(path)
	if not real then
		error(("asset not found: %q (%s)"):format(path, err or "unknown"), 2)
	end
	return real
end

function Assets.image(path)
	return love.graphics.newImage(Assets.path(path))
end

function Assets.sound(path)
	return love.audio.newSource(Assets.path(path), "static")
end

function Assets.font(path, size)
	return love.graphics.newFont(Assets.path(path), size)
end

function Assets.newFont(size)
	return love.graphics.newFont(size)
end

function Assets.manifest()
	if not index then
		buildIndex()
	end
	local out = {}
	for _, real in pairs(index) do
		out[#out + 1] = real
	end
	table.sort(out)
	return out
end

return Assets
