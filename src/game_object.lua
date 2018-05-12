GameObject = class{}

function GameObject:init(def, pos)
    -- string identifying this object type
    self.type = def.type

    self.texture = def.texture
    self.frame = def.frame or 1
    
    -- whether it acts as an obstacle or not
    self.solid = def.solid
    self.color = def.color
    
    -- dimensions
    self.width = def.width
    self.height = def.height
    self.tilePos = Vector(pos.x,pos.y)
    self.position = board:toWorldPos(self.tilePos) - Vector(TILE_SIZE - self.width, TILE_SIZE - self.height)
    self.moveSpeed = 0
    -- default empty collision callback
    self.pushable = def.pushable
    
    self.onCollide = function() end
    self.moving = false
    board:getTile(self.tilePos).prop = self
end

function GameObject:update(dt)
end

function GameObject:render(adjacentOffsetX, adjacentOffsetY)
    -- love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.states[self.state].frame or self.frame],
    --     self.x + adjacentOffsetX, self.y + adjacentOffsetY)
end

function GameObject:draw()
    love.graphics.setColor(self.color)
    love.graphics.rectangle('fill', self.position.x, self.position.y, self.width, self.height)
    love.graphics.setColor({0,0,0})
    love.graphics.setLineWidth(self.width * 0.1)
    love.graphics.rectangle('line', self.position.x, self.position.y, self.width, self.height)
end

function GameObject:push(actor, dir)
    if board:isEmpty(board.getTile(self.tilePos + dir)) then
        self.moveSpeed = actor.moveSpeed
        MoveCommand(self, dir)
    end
end