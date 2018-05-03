Tile = class{
	init = function(self, type, position)
		self.tilePos = position
		self.position = Vector(TILE_SIZE * (self.tilePos.x -1) + MAP_RENDER_OFFSET_X, -TILE_SIZE)
		self.center = (self.tilePos * TILE_SIZE) + Vector(TILE_SIZE/2, TILE_SIZE/2)
		self.isSolid = type.isSolid or false
		self.effects = {}
		self.entity = nil	--queue/stack?
		self.baseColor = type.color or {0,0,0}
		self.color = self.baseColor
		self.colors = {}
		self.onEnter = type.onEnter or function() end
		self.onExit = type.onExit or function() end
		self.prop = nil
		flux.to(self.position, 0.75, {x = self.position.x, y = (self.tilePos.y-1) * TILE_SIZE + MAP_RENDER_OFFSET_Y}):ease("backout"):delay(math.random()/(self.tilePos.y+1))
	end
}

function Tile:getEntity()
	return self.entity
end

function Tile:getProp()
	return self.prop
end

function Tile:getEffect()
	return self.effects[#self.effects]
end
 
function Tile:toggleSolid()
	self.isSolid = not self.isSolid
	if self.isSolid then
		self.color = TILE_TYPES["wall"].color
	else
		self.color = TILE_TYPES["blank"].color
	end
end

function Tile:clearColors()
	self.colors = {}
	table.insert(self.colors, self.baseColor)
end