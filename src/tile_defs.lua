TILE_IDS = {
	"blank",
	"wall",
	"spikeTrap"
}

TILE_TYPES = {
	["blank"] = {
		color = {0,0,0},
		isSolid = false,
	},
	["wall"] = {
		color = {64,64,64},
		isSolid = true
	}, 
	["spikeTrap"] = {
		color = {96,32,48},
		isSolid = false,
		value = 1,
		onEnter = function(self, unit)
			--do a damage
			print(unit.name)
			unit:damage(1)
		end
	}
}