local manifest = require("modules.cruz_frames")
local SpriteSheet = require("modules.sprite_sheet")
local Animation = require("modules.animation")

local PlayerAnims = {}

-- Row -> semantic animation, read from the sheet (Castlevania: Dawn of Sorrow,
-- Soma Cruz asset 19116). Rows with `groups` hold two animations separated by a
-- wide gap; `range` selects which group, `first`/`last` select frames within it.
local MAP = {
	idle      = { row = 01, range = 1, fps = 0.14 },
	walk      = { row = 02, fps = 0.11 },
	run       = { row = 03, range = 1, fps = 0.07 },
	dash      = { row = 03, range = 2, fps = 0.06 },
	crouchIn  = { row = 04, fps = 0.06 },
	slide     = { row = 05, fps = 0.06 },
	jump      = { row = 09, first = 1, last = 11, fps = 0.08, loop = false },
	fall      = { row = 09, first = 12, last = 19, fps = 0.09 },
	hurt      = { row = 11, fps = 0.06, loop = false },
}

local function framesFor(spec)
	local rowData = manifest.rows[spec.row]
	assert(rowData, "cruz_frames: no row " .. tostring(spec.row))

	local bounds = {}
	local start = 1
	if rowData.splits then
		for _, split in ipairs(rowData.splits) do
			bounds[#bounds + 1] = { start, split - 1 }
			start = split
		end
	end
	bounds[#bounds + 1] = { start, #rowData.frames }

	local group = bounds[spec.range or 1]
	assert(group, "cruz_frames: no group " .. tostring(spec.range) .. " for row " .. tostring(spec.row))

	local first = spec.first or group[1]
	local last = spec.last or group[2]
	local out = {}
	for i = first, last do
		if rowData.frames[i] then
			out[#out + 1] = rowData.frames[i]
		end
	end
	assert(#out > 0, "cruz_frames: empty group for row " .. tostring(spec.row))
	return out
end

function PlayerAnims.load()
	local sheet = SpriteSheet.new(manifest.image)
	local anims = {}
	for name, spec in pairs(MAP) do
		local frames = framesFor(spec)
		for _, rect in ipairs(frames) do
			assert(sheet:contains(rect),
				("cruz_frames: %s frame out of bounds (%d,%d,%d,%d)"):format(
					name, rect.x, rect.y, rect.w, rect.h))
		end
		anims[name] = Animation.new(sheet, frames, spec.fps, { loop = spec.loop })
	end
	return sheet, anims
end

PlayerAnims.MAP = MAP
PlayerAnims.manifest = manifest

return PlayerAnims
