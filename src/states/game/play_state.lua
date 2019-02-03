PlayState = {}

function PlayState:init()
	currentLevel = 0
end 

function PlayState:enter()
	board = Board()
	board:loadLevel(self.currentLevel)
   --  healer = Entity(ENTITY_DEFS['tank'], Vector(2,2))
  	-- healer:changeAnimation("idle")
  	
  	bigboy = Entity(ENTITY_DEFS['bigboy'], Vector(2,2))
  	bigboy:changeAnimation("idle")
    smallson = Entity(ENTITY_DEFS['smallson'], Vector(2,5))
    smallson2 = Entity(ENTITY_DEFS['smallson'], Vector(5,2))
    smallson:changeAnimation("idle")
    smallson2:changeAnimation("walk")

    cursor = Cursor(Vector(2,2))

    --box = GameObject(GAME_OBJECT_DEFS['box'], Vector(4,4))

 --    box.onCollide = function(actor, dir)
 --    	if board:isEmpty(board.getTile(box.tilePos + dir)) then
 --        	box.moveSpeed = actor.moveSpeed
 --        	MoveCommand(box, dir)
 --    	end
	-- end

	-- timer.every(smallson.moveSpeed * 2, function()
	-- 	local path = board:getSimplePath(smallson, healer)
 --    	local moveDir = table.remove(path).tilePos - smallson.tilePos 
 --    	smallson:move(moveDir)
	-- end)

	currentUnit = 1
    commands = {}

    allies = {bigboy}--, healer}
    enemies = {smallson,smallson2}
    entities = {allies, enemies}

    enemiesKilled = 0
end

function PlayState:leave()
end

function PlayState:draw()
	push:start()
	board:draw()

	--draw static props before entities
	for i, team in ipairs(entities) do
		for j, unit in ipairs(team) do
			if unit.alive then
				unit:draw()
			end
		end
	end

	--love.graphics.setNewFont(TILE_SIZE/2)
	love.graphics.setColor(bigboy.color)
	love.graphics.print("HP: "..bigboy.health, ACTIONBAR_RENDER_OFFSET_X - (TILE_SIZE*2), ACTIONBAR_RENDER_OFFSET_Y )
	love.graphics.print("GUT: "..#bigboy.stomach, ACTIONBAR_RENDER_OFFSET_X - (TILE_SIZE*2), ACTIONBAR_RENDER_OFFSET_Y + TILE_SIZE/2)

	love.graphics.setColor(1,1,1)
	love.graphics.print("fps: " .. love.timer.getFPS(), 0,0)
	
	push:finish()
end

function PlayState:update(dt)
	-- remove entity from the table if health is <= 0
	-- if enemiesKilled == #enemies then
 --    	gameState.switch(MenuState)
 --    end
	for i, team in ipairs(entities) do
		for j, entity in ipairs(team) do
			if entity.alive then
		        entity:processAI({room = self}, dt)
		        entity:update(dt)
    		end
		end
	end
end
 
--make sure that we're not eating inputs
function PlayState:keypressed(key)
	if key == "w" or key == "up" then
		bigboy:move(VEC_UP)
		-- entities[currentUnit]:move(VEC_UP)
	end
	if key == "a" or key == "left" then
		bigboy:move(VEC_LEFT)
		-- entities[currentUnit]:move(VEC_LEFT)
	end

	if key == "s" or key == "down" then
		bigboy:move(VEC_DOWN)
		-- entities[currentUnit]:move(VEC_DOWN)
	end
	if key == "d" or key == "right" then
		bigboy:move(VEC_RIGHT)
		-- entities[currentUnit]:move(VEC_RIGHT)
	end

	if key == "1" then
		bigboy:cast(1)
	elseif key == "2" then
		bigboy:cast(2)
	end

	if key == "r" then
		gameState.switch(PlayState)
	end
end

function PlayState:mousepressed(x, y, button, istouch)
	local nx, ny = push:toGame(x,y)
	local tile = board:getTile(board:toTilePos(Vector(nx, ny)))
	-- print(board:euclidean(healer.tilePos, tile.tilePos))
	if tile ~= nil then
		--  
		if button == 2 and board:isEmpty(tile.tilePos) then
			-- tile = Tile(TILE_TYPES["spikeTrap"], Vector(tile.tilePos.x, tile.tilePos.y))
			-- board.tiles[tile.tilePos.y][tile.tilePos.x] = tile
			local e = Entity(ENTITY_DEFS['smallson'], Vector(tile.tilePos.x, tile.tilePos.y))
			e:changeAnimation("idle")
			table.insert(entities[ENEMY_TEAM], e)
		end
	end
end

function PlayState:processAI() 
  local command = actors[currentUnit].getAction();
  --// Don't advance past the actor if it didn't take a turn. 
  if command == nil then return nil end
  
  command.perform();
  currentUnit = (currentUnit + 1) % actors.length;
end

function PlayState:endTurn()
	for i, team in ipairs(entities) do
		for j, entity in ipairs(team) do
			entity:endTurn()
		end
	end
end

function PlayState:nextLevel()
	self.currentLevel = self.currentLevel + 1
	if self.currentLevel >= 3 then
		self.currentLevel = 0
	end
	gameState.switch(MenuState)
end