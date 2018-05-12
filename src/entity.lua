Entity = class{
	init = function(self, def, position)
		-- self.tilePos = position
		-- self.position = board:toWorldPos(self.tilePos)
		self.tilePos = position
		self.position = Vector(TILE_SIZE * (self.tilePos.x -1) + MAP_RENDER_OFFSET_X, -TILE_SIZE * love.math.random(7))
		self.width = def.size.x
		self.height = def.size.y
		self.offset = Vector((TILE_SIZE - self.width)/2, (TILE_SIZE - self.height)/2)
		self.team = def.team
		self.moving = false

		self.name = def.name
		
		self.color = def.color
		self.facingRight = false

		-- self.state = stateMachine {
	 --        ['start'] = function() end,
	 --        ['play'] = function() end,
	 --        ['game-over'] = function() end
	 --    }
  
	    -- self.state:change('start')
	    
		self.moveSpeed = 0.25
		self.moveRange = 4
		self.abilities = def.abilities or {}
		self.animations = self:createAnimations(def.animations)
		self.maxAp = 5
		self.ap = self.maxAp
		self.apRegen = 3
		self.maxHealth = 3
		self.health = self.maxHealth
		self.onCollide = function() end
		self.flipOffset = def.flipOffset or 0
		self.effects = {}
		self.alive = true
		self.stomach = {}
		
		self.moving = true
		flux.to(self.position, 0.75, {x = self.position.x, y = (self.tilePos.y-1) * TILE_SIZE + MAP_RENDER_OFFSET_Y}):ease("backout"):delay(math.random()/(self.tilePos.y+1)):oncomplete(function() self.moving = false end)
		board.tiles[self.tilePos.y][self.tilePos.x].entity = self
		-- board.tiles[self.tilePos.y][self.tilePos.x].baseColor = self.color
		board.tiles[self.tilePos.y][self.tilePos.x].color = self.color--board.tiles[self.tilePos.y][self.tilePos.x].baseColor
	end
}

function Entity:createAnimations(animations)
    local animationsReturned = {}

    for k, animationDef in pairs(animations) do
        animationsReturned[k] = Animation {
            texture = animationDef.texture or 'tiles',
            frames = animationDef.frames,
            interval = animationDef.interval
        }
    end

    return animationsReturned
end

-- function Entity:changeState(name)
--     --self.state:change(name)
-- end

function Entity:update(dt)
	--self.state:update(dt)
	if self.currentAnimation then
        self.currentAnimation:update(dt)
    end
end

function Entity:damage(dmg)
    self.health = self.health - dmg
    if self.health <= 0 then
    	print("you got dead")   
    	self:kill()
    	--kill the thing
    	--gameState.switch(MenuState)
    end
end

function Entity:heal(hp)
    self.health = self.health + hp
    self.health = math.min(self.health, self.maxHealth)
end

function Entity:processAI(params, dt)
end

function Entity:changeAnimation(name)
    self.currentAnimation = self.animations[name]
end

-- function Entity:draw()
-- 	love.graphics.setColor(self.color)
-- 	love.graphics.rectangle("fill", self.position.x, self.position.y, TILE_SIZE, TILE_SIZE)
-- end

function Entity:draw()
	local anim = self.currentAnimation
	local scaledX, scaledY, scaledW, scaledH = gFrames[anim.texture][anim:getCurrentFrame()]:getViewport() --why am i doing this every frame...
	scaledW = self.width/scaledW
	scaledH = self.height/scaledH 	
	
	if self.facingRight then
		scaledW = -scaledW
	end

	-- love.graphics.setColor(self.color)				
	-- love.graphics.rectangle("fill", self.position.x, self.position.y, TILE_SIZE, TILE_SIZE)
	-- love.graphics.setColor(0,0,0)				
	-- love.graphics.rectangle("line", self.position.x, self.position.y, TILE_SIZE, TILE_SIZE)
	love.graphics.setColor({255, 255, 255}) --or white
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()], self.position.x + self.offset.x , self.position.y + self.offset.y, 0, scaledW, scaledH)
end

--use correct number of ap
function Entity:move(dir)
	
	local tilePos = self.tilePos + dir
	if board:isEmpty(tilePos) and not self.moving then
		if (self.facingRight and dir == VEC_LEFT) or (not self.facingRight and dir == VEC_RIGHT) then
			self:flip()
		end

		MoveCommand(self, dir, false):execute()
	end
end

--this is definitely gonna become a problem some day...
function Entity:flip()
	self.facingRight = not self.facingRight
	if self.facingRight then
		self.offset.x = self.offset.x + self.flipOffset
	else
		self.offset.x = self.offset.x - self.flipOffset
	end
end

function Entity:cast(i)
	if self.ap >= self.abilities[i].cost  and self.abilities[i]  ~= nil then
		Ability(self.abilities[i], self):cast()
	end
end

function Entity:endTurn()
	self.ap = math.min(self.ap + self.apRegen, self.maxAp)
	--end of turn effects and stuff
end

function Entity:startTurn()
	--beginning of turn effects and stuff
end

function Entity:kill()
	self.alive = false
	
	if self.team == ENEMY_TEAM then
		enemiesKilled = enemiesKilled + 1
	end

	-- board.tiles[self.tilePos.y][self.tilePos.x].baseColor = {0,0,0}
	-- board.tiles[self.tilePos.y][self.tilePos.x].color = {0,0,0}
	board.tiles[self.tilePos.y][self.tilePos.x].entity = nil
end

function Entity:grow(nx, ny)
	-- self.width = self.width * nx
	-- self.height = self.height * ny
	flux.to(
		self,
		1, 
		{ 
			width = self.width * nx,
			height = self.height * ny
		}
	)
	:ease("backout")
end