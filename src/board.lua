--1D-array for tiles?
Board = class{
	init = function(self)
		self.entities = {}
		self.tiles = {}
		self.gates = {}

		self.boardSize = Vector(9, 9)
		self.position = Vector(MAP_RENDER_OFFSET_X, MAP_RENDER_OFFSET_Y)
		
		self:loadTestMap()
	end
}

function Board:draw()
	for y, row in ipairs(self.tiles) do
		for x, cell in ipairs(row) do
			cell:draw()
			--love.graphics.rectangle('line', self.position.x + (x - 1) * TILE_SIZE, self.position.y + (y - 1) * TILE_SIZE, TILE_SIZE, TILE_SIZE)
		end
	end
end

function Board:loadTestMap()
	for y=1, self.boardSize.y do
		table.insert(self.tiles, {})

		for x=1, self.boardSize.x do
			if x == 1 or y == 1 or y == self.boardSize.y or x == self.boardSize.x then
				self.tiles[y][x] = Tile(TILE_TYPES["wall"], Vector(x,y))
			else
				self.tiles[y][x] = Tile(TILE_TYPES["blank"], Vector(x,y))
			end
		end
	end

	-- self.tiles[2][3] = Tile(TILE_TYPES["portal"], Vector(3, 2))
	-- self.tiles[7][7] = Tile(TILE_TYPES["portal"], Vector(7,7))
	-- self.tiles[7][7].connectedPortal = self.tiles[2][3]
	-- self.tiles[2][3].connectedPortal = self.tiles[7][7]
	self.tiles[8][8] = Tile(TILE_TYPES["gate"], Vector(8,8))
	table.insert(self.gates, self.tiles[8][8])
end

function Board:update(dt)
end

function Board:reset()
	self.tiles = {}
end

function Board:checkGates(unit)
	for i, gate in ipairs(self.gates) do

		gate.locked = #unit.stomach < gate.goal
		if gate.locked then
			gate.color = TILE_TYPES["gate"].lockedColor
		else
			gate.color = TILE_TYPES["gate"].unlockedColor
		end
	end
end

--This gets the target for if a shot hits the first object (like the turret)
function Board:GetProjectileEnd(p1,p2,profile)
	profile = profile or PATH_PROJECTILE
	local direction = GetDirection(p2 - p1)
	local target = p1 + DIR_VECTORS[direction]

	while not Board:IsBlocked(target, profile) do
		target = target + DIR_VECTORS[direction]
	end

	if not Board:IsValid(target) then
		target = target - DIR_VECTORS[direction]
	end
	
	return target
end

function Board:toWorldPos(tile)
	return Vector((tile.x-1) * TILE_SIZE + self.position.x, (tile.y-1) * TILE_SIZE + self.position.y)
end

function Board:toTilePos(tile)
	return Vector(math.floor((tile.x - self.position.x)/TILE_SIZE) + 1, math.floor((tile.y - self.position.y)/TILE_SIZE) + 1)
end

function Board:render()
end

function Board:processAI(params, dt)
end

--check if path of given type to target is blocked at all
function Board:isBlocked(target, path)
end

--BFS
function Board:getSimplePath(p1, p2)
	local frontier = {}
	local goal = self:getTile(p2.tilePos)
	table.insert(frontier, self:getTile(p1.tilePos))
	visited = {}
	cameFrom = {}

	while #frontier > 0 do
		current = table.remove(frontier, 1)

		if current == goal then
			--build the path
			current = goal 
			path = {}
			while current ~= self:getTile(p1.tilePos) do
			   table.insert(path, current)
			   current = cameFrom[current]
			end
			return path
		end

		--filter tiles with people on them
		local neighbors = self:getNeighbors(current.tilePos)
		for i, n in ipairs(neighbors) do
			if not visited[n] and n:getProp() == nil and n:getEntity() == nil then  
				table.insert(frontier, n)
				visited[n] = true
				cameFrom[n] = current
				--n.color = {64, 255, 255}	
			end
		end	
	end

	print("no path found")
	return {}
end

--highlight reachable spaces for movement/targeting
function Board:getSimpleReachable(point, dist)
	local tiles = {}
	for y, row in ipairs(self.tiles) do
		for x, tile in ipairs(row) do
			if self:manhattan(point, tile.tilePos) <= dist and self:isEmpty(tile.tilePos) then
				table.insert(tiles, tile)
			end
		end
	end

	return tiles
end

-- if this tile's move cost is less than the total distance the unit can move
--    For each of tile's neighbors
--      cost of movement = current tile's movement cost + neighbor's terrain difficulty
--      if neighbor has no move cost OR its move cost > cost of movement
--        neighbors movement cost = cost of movement
--        add neighbor to list of tiles whose neighbors you need to check
function Board:getReachable(point, dist)
	local tiles = {}
	for y, row in ipairs(self.tiles) do
		for x, tile in ipairs(row) do
			local path = self:getSimplePath(self.tiles[point.y][point.x], tile)
			if #path <= dist then
				for i, n in ipairs(path) do
					if not contains(tiles, n) then
						table.insert(tiles, n)
					end
				end
			end
		end
	end

	return tiles
end

function Board:getTile(tile)
	if self:isInBounds(tile) then
		return self.tiles[tile.y][tile.x]
	end
end

function Board:isEmpty(tile)
	return self:isInBounds(tile) and self:entityAt(tile) == nil and not self.tiles[tile.y][tile.x].isSolid
end

function Board:entityAt(tile)
	local entity = self.tiles[tile.y][tile.x]:getEntity()
	if entity ~= nil then
		return entity
	end
end

function Board:isInBounds(tile)
	return tile.x <= #self.tiles[1] and tile.x > 0 and tile.y <= #self.tiles  and tile.y > 0
end

function Board:getNeighbors(tile)
	local neighbors = {}

	--filter out walls and invalid stuff
	for i, dir in ipairs(DIR_VECTORS) do
		local tile = board:getTile(tile + dir)
		if tile ~= nil and not tile.isSolid then
			table.insert(neighbors, tile)
		end
	end

	return neighbors
end

function Board:manhattan(p1,p2)
	return math.abs(p1.x - p2.x) + math.abs(p1.y - p2.y)
end

function Board:euclidean(p1, p2)
	return math.floor(math.sqrt(math.pow(p2.x - p1.x, 2) + math.pow(p2.y - p1.y,2)))
end

function Board:clear()
	for y, row in ipairs(self.tiles) do
		for x, tile in ipairs(row) do
    		if self:isEmpty(tile.tilePos) then
    			tile.color = tile.baseColor
    		end
		end
	end
end

function Board:clearAll()
	for y, row in ipairs(self.tiles) do
		for x, tile in ipairs(row) do
    		if self:isEmpty(tile.tilePos) then
    			tile.baseColor = {0,0,0}
    			tile.color = tile.baseColor
    		end
		end
	end
end

function Board:getSquare(center, size)
end