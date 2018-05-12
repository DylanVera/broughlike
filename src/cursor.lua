Cursor = class{
	init = function(self, pos)
		self.tilePos = pos
		self.moving = false;
		self.position = board:toWorldPos(self.tilePos)
		self.moveSpeed = 0.1
	end
}

function Cursor:render()
	love.graphics.setColor(255,255,255)
	love.graphics.getLineWidth(TILE_SIZE/16)
	love.graphics.rectangle('line', self.position.x, self.position.y, TILE_SIZE, TILE_SIZE)
end

function Cursor:move(dir)
	if board:isInBounds(self.tilePos + dir) then
		self.tilePos = self.tilePos + dir
		self.position = board:toWorldPos(self.tilePos)
	end 
end