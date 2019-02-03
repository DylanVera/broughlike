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
		color = {0.5,0.5,0.5},
		isSolid = true
	}, 
	["spikeTrap"] = {
		color = {0.375, 0.1255, 0.1875},
		isSolid = false,
		value = 1,
		onEnter = function(self, unit)
			print(unit.name)
			unit:damage(self.value)
		end
	},
	["portal"] = {
		color = {0.25, 0.125, 0.5},
		isSolid = false,
		connectedPortal = nil,
		onEnter = function(self, unit)
			if self.connectedPortal:getEntity() == nil then 
				self.entity = nil
				self.connectedPortal.entity = unit
				unit.tilePos = Vector(self.connectedPortal.tilePos.x, self.connectedPortal.tilePos.y);
				unit.position = Vector(self.connectedPortal.position.x, self.connectedPortal.position.y)	
				print("Teleporting "..unit.name.." from ("..self.tilePos.x..","..self.tilePos.y..") to ("..self.connectedPortal.tilePos.x..","..self.connectedPortal.tilePos.y..")")
			end
		end
	},
	["gate"] = {
		lockedColor = {0.5, 0.125, 0.125},
		unlockedColor = {0.125, 0.5, 0.125},
		color = {0.5, 0.125, 0.125},
		isSolid = false,
		goal = 2,
		onEnter = function(self)
			if not self.locked then
				PlayState:nextLevel()
			end
		end
	}
}