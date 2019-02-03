MenuState = {}

function MenuState:init()
end

function MenuState:enter()
end

function MenuState:leave()
end

function MenuState:draw()
	push:start()
	love.graphics.setColor({1,1,1})
	love.graphics.printf("NO", 0, math.floor(VIRTUAL_HEIGHT/2), VIRTUAL_WIDTH, "center")
	push:finish()
end

function MenuState:update(dt)
	if suit.Button("TestMap", 0,0, TILE_SIZE * 4, TILE_SIZE).hit then
		PlayState.currentLevel = 0
    	gameState.switch(PlayState)
    end

    for i = 1, #MAP_DATA do
    	if suit.Button("Level "..i, 0, (i) * TILE_SIZE, TILE_SIZE * 4, TILE_SIZE).hit then
    		PlayState.currentLevel = i
    		gameState.switch(PlayState)
    	end
    end
end

function MenuState:keypressed(key)
	if PlayState.currentLevel == nil then
		PlayState.currentLevel = 0
	end
	gameState.switch(PlayState)
end