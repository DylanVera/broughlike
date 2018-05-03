MenuState = {}

function MenuState:init()
end

function MenuState:enter()
end

function MenuState:leave()
end

function MenuState:draw()
	push:start()
	love.graphics.setColor({255,255,255})
	love.graphics.printf("NO", 0, math.floor(VIRTUAL_HEIGHT/2), VIRTUAL_WIDTH, "center")
	push:finish()
end

function MenuState:update(dt)
end

function MenuState:keypressed(key)
	gameState.push(PlayState)
end