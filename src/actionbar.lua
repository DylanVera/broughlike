ActionBar = class{
	init = function(self, actor)
		self.actor = actor
		self.abilities = actor.abilities
		self.position = Vector(ACTIONBAR_RENDER_OFFSET_X, ACTIONBAR_RENDER_OFFSET_Y)
	end
}

function ActionBar:cast(i)
	self.actor:cast(i)
end

function ActionBar:changeActor(actor)
	self.actor = actor
	self.abilities = actor.abilities
end

function ActionBar:draw()
	for i=1,MAX_ACTIONBAR_SIZE do
		love.graphics.setColor(128,128,128)
		love.graphics.rectangle("fill", self.position.x + (i - 1) * TILE_SIZE, self.position.y, TILE_SIZE, TILE_SIZE)
		love.graphics.setColor(0,0,0)
		love.graphics.rectangle("line", self.position.x + (i - 1) * TILE_SIZE, self.position.y, TILE_SIZE, TILE_SIZE)
		love.graphics.setNewFont(TILE_SIZE/4)
		love.graphics.print(i, self.position.x + (TILE_SIZE * 0.1) + (i - 1) * TILE_SIZE, self.position.y + (TILE_SIZE * 0.1))
	end
end

function ActionBar:update(dt)
	for i, ability in ipairs(self.abilities) do
		if suit.Button(i, self.position.x + (i - 1), self.position.y, TILE_SIZE, TILE_SIZE).hit then
	    	local neighbors = board:getNeighbors(healer.tilePos)
	    	for i,n in ipairs(neighbors) do
	    		n.color = {255,64,96}
	    	end		
    	end
	end
end