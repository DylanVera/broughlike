Tile = class{
	init = function(self, type, position)
		self.tilePos = position
		self.position = Vector(TILE_SIZE * (self.tilePos.x -1) + MAP_RENDER_OFFSET_X, -TILE_SIZE)
		self.center = (self.tilePos * TILE_SIZE) + Vector(TILE_SIZE/2, TILE_SIZE/2)
		self.isSolid = type.isSolid or false
		self.effects = {}
		self.entity = nil	--queue/stack?
		self.baseColor = type.color
		self.color = self.baseColor

		self.onEnter = type.onEnter or function() end
		self.onExit = type.onExit or function() end
		self.prop = nil
		self.goal = type.goal or 0
		self.locked = self.goal > 0

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

function Tile:draw()
	love.graphics.setColor(self.color)
	love.graphics.rectangle('fill', self.position.x, self.position.y, TILE_SIZE, TILE_SIZE)
	--love.graphics.rectangle('fill', self.position.x + (x - 1) * TILE_SIZE, self.position.y + (y - 1) * TILE_SIZE, TILE_SIZE, TILE_SIZE)
	love.graphics.setColor(0, 0, 0)
	love.graphics.setLineWidth(TILE_SIZE * 0.1)
	love.graphics.rectangle('line', self.position.x, self.position.y, TILE_SIZE, TILE_SIZE)

	if self.goal > 0 then
		love.graphics.print(self.goal - #bigboy.stomach, self.position.x, self.position.y)
	end
end

function Tile:clearColors()
	self.colors = {}
	table.insert(self.colors, self.baseColor)
end