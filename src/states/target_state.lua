TargetState = {}

function TargetState:init()
end

function TargetState:update(dt)
	PlayState:update(dt)
end

function TargetState:draw()
	PlayState:draw()
	
	push:start()
	for i,n in ipairs(self.tiles) do
		love.graphics.setColor({1, 0.25, 0.375, 0.3})
		love.graphics.rectangle('fill', n.position.x, n.position.y, TILE_SIZE, TILE_SIZE)
		love.graphics.setColor({0,0,0})
		love.graphics.setLineWidth(TILE_SIZE * 0.1)
		love.graphics.rectangle('line', n.position.x, n.position.y, TILE_SIZE, TILE_SIZE)
	end
	cursor:render()

	push:finish()
end	

function TargetState:enter()
	cursor.tilePos = self.tiles[1].tilePos
	cursor.position = self.tiles[1].position

	for i,n in ipairs(self.tiles) do
		if self.ability.targetType == UNIT_TARGET or self.ability.targetType == TILE_TARGET then
			if n:getEntity() ~= nil then
				cursor.tilePos = n.tilePos
				cursor.position = n.position
			end
		end
	end
end

function TargetState:leave()
	for i,n in ipairs(self.tiles) do
		n.color = n.baseColor
	end
end

function TargetState:keypressed(key)
	if key == "w" or key == "up" then
		cursor:move(VEC_UP)
		-- entities[currentUnit]:move(VEC_UP)
	end
	if key == "a" or key == "left" then
		cursor:move(VEC_LEFT)
		-- entities[currentUnit]:move(VEC_LEFT)
	end
	if key == "s" or key == "down" then
		cursor:move(VEC_DOWN)
		-- entities[currentUnit]:move(VEC_DOWN)
	end
	if key == "d" or key == "right" then
		cursor:move(VEC_RIGHT)
		-- entities[currentUnit]:move(VEC_RIGHT)
	end
	
	if key == "x" or key == "space" or key == "return" or key == "e" then
		self:checkTarget()
	end

	if key == "escape" then
		gameState.pop()
	end
end

function TargetState:keyreleased(key)
	if key == "2" or key == "space" or key == "return" or key == "e" then
		self:checkTarget()
	end
end

function TargetState:mousepressed(x, y, button, isTouch)
	local nx, ny = push:toGame(x,y)
	local tile = board:getTile(board:toTilePos(Vector(nx, ny)))
	cursor.tilePos = tile.tilePos
	cursor.position = tile.position
	
	if tile ~= nil then
		if button == 1 then		
			self:checkTarget()
		end
	end
end	

function TargetState:changeTargetingType()
	
end

function TargetState:checkTarget()
	local tile = board:getTile(cursor.tilePos)
	local entity = board:entityAt(cursor.tilePos)
	if tile ~= nil then	
		if contains(self.tiles, tile) then
			if self.ability.targetType == UNIT_TARGET and entity ~= nil then
				self.ability:execute(entity)			
			end
			if self.ability.targetType == TILE_TARGET then
				if entity ~= nil then
					self.ability:execute(entity)
				else
					self.ability:execute(tile)
				end
			end
			gameState.pop()
		else
			gameState.pop()
		end
	else
		gameState.pop()
	end
end