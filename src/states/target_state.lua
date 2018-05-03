TargetState = {}

function TargetState:init()
end

function TargetState:update(dt)
	PlayState:update(dt)
end

function TargetState:draw()
	PlayState:draw()
	push:start()
	cursor:render()
	push:finish()
end	

function TargetState:enter()
	for i,n in ipairs(self.tiles) do
		n.color = {255,64,96}
	end
	cursor.tilePos = self.tiles[1].tilePos
	cursor.position = board:toWorldPos(cursor.tilePos)
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
	
	if key == "x" or key == "space" then
		self:checkTarget()
	end

	if key == "escape" then
		gameState.pop()
	end
end

function TargetState:mousepressed(x, y, button, isTouch)
	local nx, ny = push:toGame(x,y)
	local tile = board:getTile(board:toTilePos(Vector(nx, ny)))
	cursor.tilePos = tile.tilePos
	cursor.position = board:toWorldPos(cursor.tilePos)
	
	if tile ~= nil then
		if button == 1 then		
			self:checkTarget()
		end
	end
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
		end
	end
	gameState.pop()
end