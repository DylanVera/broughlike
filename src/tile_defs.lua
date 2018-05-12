TILE_IDS = {
	"blank",
	"wall",
	"spikeTrap",
	"portal",
	"gate"
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
	},
	["portal"] = {
		color = {64, 32, 128},
		isSolid = false,
		connectedPortal = nil,
		onEnter = function(self, unit)
			if self.connectedPortal:getEntity() == nil then 
				unit.tilePos = Vector(self.connectedPortal.tilePos.x, self.connectedPortal.tilePos.y);
				unit.position = board:toWorldPos(unit.tilePos)
				self.entity = nil
				self.connectedPortal.entity = unit
			end
		end
	},
	["gate"] = {
		lockedColor = {64, 32, 32},
		unlockedColor = {32, 64, 32},
		color = {64, 32, 32},
		isSolid = false,
		goal = 2,
		onEnter = function(self)
			if not self.locked then
				gameState.switch(MenuState)
			end
		end
	}
}