UnitState = {}

function UnitState:init()
	
end

function UnitState:update(dt)
	PlayState:update(dt)
end

function UnitState:draw()
	PlayState:draw()
	push:start()
	actionbar:draw()
	love.graphics.setNewFont(TILE_SIZE/2)
	love.graphics.setColor(self.unit.color)
	love.graphics.print("HP: "..self.unit.health, ACTIONBAR_RENDER_OFFSET_X - (TILE_SIZE*2), ACTIONBAR_RENDER_OFFSET_Y )
	love.graphics.print("AP: "..self.unit.ap, ACTIONBAR_RENDER_OFFSET_X - (TILE_SIZE*2), ACTIONBAR_RENDER_OFFSET_Y + TILE_SIZE/2)
	push:finish()
end

function UnitState:keypressed(key)

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

	--just use tile pos not
	if key == "x" then
		-- local path = board:getSimplePath(self.unit, cursor)
		-- for i, t in ipairs(path) do
		-- 	local moveDir = table.remove(path).tilePos - self.unit.tilePos
  --   		self.unit:move(moveDir)()
		-- end
		local path = board:getSimplePath(self.unit, cursor)
		local moveDir = cursor.tilePos - self.unit.tilePos
		if #path > 0 then
			self.unit:move(path)
		end
    	--self.unit.position = board:toWorldPos(self.unit.tilePos)
	end

	if key == "1" then
		actionbar:cast(1)
	elseif key == "2" then
		actionbar:cast(2)
	elseif key == "3" then
		actionbar:cast(3)
	elseif key == "4" then
		actionbar:cast(4)
	end

	if key == "space" then
		gameState.pop()
	end
end

function UnitState:enter()
	actionbar:changeActor(self.unit)
	self:updateMoveRange()
end

function UnitState:leave()
	-- board:clear()
	-- for i, t in ipairs(self.moveRange) do
	-- 	t.color = t.baseColor
	-- end	
end

function UnitState:updateMoveRange()
	self.moveRange = board:getSimpleReachable(self.unit.tilePos, self.unit.ap)
	for i, t in ipairs(self.moveRange) do
		t.color = {64, 196, 128}
	end	
end	

function UnitState:mousepressed(x, y, button, isTouch)
	PlayState:mousepressed(x,y,button,isTouch)
	local nx, ny = push:toGame(x,y)
	local tile = board:getTile(board:toTilePos(Vector(nx, ny)))
	if tile ~= nil then
		if button == 1 then
			local path = board:getSimplePath(self.unit, tile)
			if #path > 0 then
	    		local moveDir = path[#path].tilePos - self.unit.tilePos
	    		self.unit:move(path)
	    	end
		end
	end	
	if button == 2 then
		gameState.pop()
	end
end