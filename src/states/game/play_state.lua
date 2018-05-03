PlayState = {}

function PlayState:init()
end 

function PlayState:enter()
	board = Board()
   --  healer = Entity(ENTITY_DEFS['tank'], Vector(2,2))
  	-- healer:changeAnimation("idle")
  	bigboy = Entity(ENTITY_DEFS['bigboy'], Vector(2,2))
  	bigboy:changeAnimation("idle")
    enemy = Entity(ENTITY_DEFS['enemy'], Vector(8,8))
    enemy2 = Entity(ENTITY_DEFS['enemy'], Vector(4,4))
    enemy:changeAnimation("idle")
    enemy2:changeAnimation("idle")
    cursor = Cursor(Vector(2,2))

    --box = GameObject(GAME_OBJECT_DEFS['box'], Vector(4,4))

 --    box.onCollide = function(actor, dir)
 --    	if board:isEmpty(board.getTile(box.tilePos + dir)) then
 --        	box.moveSpeed = actor.moveSpeed
 --        	MoveCommand(box, dir)
 --    	end
	-- end

	-- timer.every(enemy.moveSpeed * 2, function()
	-- 	local path = board:getSimplePath(enemy, healer)
 --    	local moveDir = table.remove(path).tilePos - enemy.tilePos 
 --    	enemy:move(moveDir)
	-- end)?>
	currentUnit = 1
    commands = {}
    
    actionbar = ActionBar(bigboy)


    allies = {bigboy}--, healer}
    enemies = {enemy, enemy2}
    entities = {allies, enemies}
    enemiesKilled = 0
end

function PlayState:leave()
end

function PlayState:draw()
	push:start()
	board:draw()

	--board is one room, what
	for i, team in ipairs(entities) do
		for j, unit in ipairs(team) do
			if unit.alive then
				unit:render()
			end
		end
	end

	actionbar:draw()
	love.graphics.setNewFont(TILE_SIZE/2)
	love.graphics.setColor(bigboy.color)
	love.graphics.print("HP: "..bigboy.health, ACTIONBAR_RENDER_OFFSET_X - (TILE_SIZE*2), ACTIONBAR_RENDER_OFFSET_Y )
	love.graphics.print("GUT: "..#bigboy.stomach, ACTIONBAR_RENDER_OFFSET_X - (TILE_SIZE*2), ACTIONBAR_RENDER_OFFSET_Y + TILE_SIZE/2)

	love.graphics.setColor(255,255,255)
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
   
    if suit.Button("Clear", TILE_SIZE, TILE_SIZE, TILE_SIZE * 4, TILE_SIZE).hit then
    	board:clear()
    end

    if suit.Button("End Turn", TILE_SIZE, TILE_SIZE * 2, TILE_SIZE * 4, TILE_SIZE).hit then
    	self:endTurn()
    end
end

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
		actionbar:cast(1)
	elseif key == "2" then
		actionbar:cast(2)
	elseif key == "3" then
		actionbar:cast(3)
	elseif key == "4" then
		actionbar:cast(4)
	end
end

function PlayState:mousepressed(x, y, button, istouch)
	local nx, ny = push:toGame(x,y)
	local tile = board:getTile(board:toTilePos(Vector(nx, ny)))
	-- print(board:euclidean(healer.tilePos, tile.tilePos))
	if tile ~= nil then
		if button == 1 then
			cursor.tilePos = tile.tilePos
			cursor.position = board:toWorldPos(cursor.tilePos)
			if tile:getEntity() ~= nil then
				UnitState.unit = tile:getEntity()
				gameState.push(UnitState)
			end
		end
		if button == 2 then
			tile = Tile(TILE_TYPES["spikeTrap"], Vector(tile.tilePos.x, tile.tilePos.y))
			board.tiles[tile.tilePos.y][tile.tilePos.x] = tile
		end
	end
end

function PlayState:processAI() 
  --local command = actors[_currentActor].getAction();

  --// Don't advance past the actor if it didn't take a turn. 
  --if action == nil then return nil end

  --action.perform();
  --_currentActor = (_currentActor + 1) % actors.length;
end

function PlayState:endTurn()
	for i, team in ipairs(entities) do
		for j, entity in ipairs(team) do
			entity:endTurn()
		end
	end
end