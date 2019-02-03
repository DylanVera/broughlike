--1D-array for tiles?
Board = class{
	init = function(self)
		self.entities = {}
		self.tiles = {}
		self.gates = {}

		self.boardSize = nil
		self.position = Vector(MAP_RENDER_OFFSET_X, MAP_RENDER_OFFSET_Y)
		print("BoardPosition: "..self.position.x..","..self.position.y)
		print()
		-- self:loadTestMap()
		-- self:loadMap("src/mapOne.map")
		-- self:loadBoard("src/mapTwo.map")
	end
}

function Board:draw()
	for y, row in ipairs(self.tiles) do
		for x, cell in ipairs(row) do
			cell:draw()
		end
	end
end

function Board:loadLevel(level)
	if level == 0 then
		self:loadTestMap()
	elseif level > 0 and level <= #MAP_DATA then
		self:loadBoard(MAP_DATA[level])
	end
end

--index or string path?
function Board:loadBoard(map)
	contents, size = love.filesystem.read( map, size )
	--print(contents)

	local y = 1
	local xPos = 1
	for line in love.filesystem.lines(map) do
		-- if line == "\n" then
		-- 	board:loadEntities()
		-- 	break
		-- else
			print(line)
			table.insert(self.tiles, {})
			--print(line)
			for x = 1, #line do
				tileID = line:sub(x,x) + 1
	    		table.insert(self.tiles[y], Tile(TILE_TYPES[TILE_IDS[tileID]], Vector(x,y)))
	    		xPos = x

	    		if(tileID == 5) then
	    			table.insert(self.gates, self.tiles[y][x])
	    		end
	    	end
	    	y = y + 1
	    -- end
	end
	self.boardSize = Vector(xPos,y)
	print("Loaded "..self.boardSize.x..","..self.boardSize.y.." sized board")
	
	-- for y=1, self.boardSize.y do
	-- 	table.insert(self.tiles, {})

	-- 	for x=1, self.boardSize.x do
	-- 		if x == 1 or y == 1 or y == self.boardSize.y or x == self.boardSize.x then
	-- 			self.tiles[y][x] = Tile(TILE_TYPES["wall"], Vector(x,y))
	-- 		else
	-- 			self.tiles[y][x] = Tile(TILE_TYPES["blank"], Vector(x,y))
	-- 		end
	-- 	end
	-- end
	-- self.position = self:centerBoard()
	-- print("at position of "..self.position.x..", "..self.position.y)
	-- print(self.tiles[1][1].position)
end

function Board:loadEntities()
	print("figure out loading entities...")
end

--TODO: this messes up board/worldpos calculations
function Board:centerBoard()
	local widestRow = 0
	for y, row in ipairs(self.tiles) do
		if #row > widestRow then
			widestRow = #row
		end
	end

	local offsetX = (VIRTUAL_WIDTH - (widestRow * TILE_SIZE)) / 2
	local offsetY = (VIRTUAL_HEIGHT  - (#self.tiles * TILE_SIZE)) / 2
	print("board offset of "..offsetX..", "..offsetY)
	return Vector(offsetX, offsetY)
end

function Board:loadTestMap()
	self.boardSize = Vector(9,9)
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

	self:centerBoard()
	
	self.tiles[2][3] = Tile(TILE_TYPES["portal"], Vector(3, 2))
	self.tiles[7][7] = Tile(TILE_TYPES["portal"], Vector(7,7))
	self.tiles[7][7].connectedPortal = self.tiles[2][3]
	self.tiles[2][3].connectedPortal = self.tiles[7][7]
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

--these two functions are all fucky when you change map size/move the origin of the board to recenter
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

function Board:heuristic(cost)
end

--djikstra -> A*
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
function Board:getReachableTiles(point, dist)
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

--grid walk to check for obstacles in path
function Board:walkPath(p1, p2)
    dx = p2.x - p1.x
    dy = p2.y - p1.y
    nx = math.abs(dx)
    ny = math.abs(dy)

    if dx > 0 then
    	sign_x = 1
    else
    	sign_x = -1
    end

    if dy > 0 then
    	sign_y = 1
   	else
   		sign_y = -1
   	end

    p = Vector(p1.x, p1.y);
    points = {self.tiles[p.y][p.x]}
    local ix = 0
    local iy = 0
     while ix < nx or iy < ny do
        if ((0.5+ix) / nx < (0.5+iy) / ny) then
            p.x = p.x + sign_x
            ix = ix + 1
        else 
            p.y = p.y + sign_y
            iy = iy + 1
        end

        if self.tiles[p.y][p.x].isSolid then
        	break
        end
        table.insert(points, self.tiles[p.y][p.x]);
    end

    return points
end

function Board:isReachable(p1, p2)
	dx = p2.x - p1.x
    dy = p2.y - p1.y
    nx = math.abs(dx)
    ny = math.abs(dy)

    if dx > 0 then
    	sign_x = 1
    else
    	sign_x = -1
    end

    if dy > 0 then
    	sign_y = 1
   	else
   		sign_y = -1
   	end

    p = Vector(p1.x, p1.y);
    points = {self.tiles[p.y][p.x]}
    local ix = 0
    local iy = 0
     while ix < nx or iy < ny do
        if ((0.5+ix) / nx < (0.5+iy) / ny) then
            p.x = p.x + sign_x
            ix = ix + 1
        else 
            p.y = p.y + sign_y
            iy = iy + 1
        end

        if self.tiles[p.y][p.x].isSolid then
        	return false
        end
    end

    return true
end