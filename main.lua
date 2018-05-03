require("src.dependencies")

function love.load()
    love.graphics.setBackgroundColor(0,0,0)
    love.window.setTitle("Tiny X-Com")

    math.randomseed(os.time())
    love.math.setRandomSeed(os.time())
    love.graphics.setDefaultFilter("nearest", "nearest", 1)
    
    io.stdout:setvbuf("no")

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        pixelperfect = true,
        highdpi = true,
        canvas = false
    })
    screen:setDimensions(push:getDimensions())
    gStateStack = StateStack()
    -- gStateStack:push(MenuState())

    -- love.keyboard.keysPressed = {}
    gameState.registerEvents()
    gameState.switch(MenuState)
    -- gameState.push(MenuState)   
end

function love.update(dt)
	flux.update(dt)
	timer.update(dt)
	screen:update(dt)
    
    -- gStateStack:update(dt)

end

function love.draw()
    -- push:start()

    suit.draw()
	screen:apply()
    -- push:finish()
    -- gStateStack:render()

end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    if key == "end" then
        love.event.quit()
    end
end

