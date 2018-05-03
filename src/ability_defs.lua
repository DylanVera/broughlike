ABILITY_DEFS = {
	["heal"] = {
		cost = 1,
		targetType = UNIT_TARGET,
		value = 1,
		range = 2,
		cast = function(self)
			local neighbors = board:getNeighbors(self.actor.tilePos)
	    	
	    	TargetState.tiles = neighbors
	    	TargetState.ability = self
	    	gameState.push(TargetState)
	    	--handle click event for targeting while in casting state
	    	--figure out a targeting state to  deal 
		end,
		execute = function(self, target) 
			print("heal")
			target:heal(self.value)
		end,
		undo = function()
		end
	},
	["smite"] = {
		cost = 1,
		range = 2,
		value = 2,
		targetType = UNIT_TARGET,
		execute = function()
			print("smite")
		end,
		undo = function()
		end
	},	
	["strike"] = {
		cost = 1,
		value = 2,
		targetType = UNIT_TARGET,
		cast = function(self)
			local neighbors = board:getNeighbors(self.actor.tilePos)
	    	
	    	TargetState.tiles = neighbors
	    	TargetState.ability = self
	    	gameState.push(TargetState)
		end,
		execute = function(self, target)
			print("strike")
			target:damage(self.value)
			screen:shake(100)
			--find out target
			-- target:damage(damage)
		end,
		undo = function()
		end
	},
	["block"] = {	
		cost = 1,
		cd = 2,
		targetType = NONE,
		execute = function()
			print("block")
		end,
		undo = function()
		end
	},
	["taunt"] = {

	},
	["cleave"] = {

	},
	["eat"] = {
		cost = 1,
		value = 2,
		targetType = UNIT_TARGET,
		cast = function(self)
			local neighbors = board:getNeighbors(self.actor.tilePos)
	    
	    	TargetState.tiles = neighbors
	    	TargetState.ability = self
	    	gameState.push(TargetState)
		end,
		execute = function(self, target)
			print("eating")
			
			table.insert(self.actor.stomach, target)
			--lerp it to the player or something
			--we can lerp the size and stuff too
			local size = Vector(target.width, target.height)

			flux.to(
				target.position,
				0.3,
				{
					x = self.actor.position.x + self.actor.width/2,
					y = self.actor.position.y + self.actor.height/2
				}	
			)
			:ease("cubicin")
			:oncomplete(function()
				target:kill()
			end)

			flux.to(
				target,
				0.5,
				{
					width = 0,
					height = 0
				}
			)
		end,
		undo = function()
		end 
	},
	["barf"] = {
		cost = 1,
		cd = 0,
		range = 2,
		targetType = TILE_TARGET,
		cast = function(self)
			if #self.actor.stomach > 0 then
				local tiles = {}
				for y, row in ipairs(board.tiles) do
					for x, cell in ipairs(row) do
						if board:euclidean(self.actor.tilePos, cell.tilePos) <= self.range and 
							cell ~= board.tiles[self.actor.tilePos.y][self.actor.tilePos.x] and board:isEmpty(cell.tilePos) then
							table.insert(tiles, cell)
						end
					end
				end

				TargetState.tiles = tiles
				TargetState.ability = self
				gameState.push(TargetState)
			else
				print("empty stomach :(")
			end
		end,
		--damage entities in target tile or what?
		execute = function(self, target)
			print("barfing")

			local barfee = table.remove(self.actor.stomach)
			barfee.alive = true
			barfee.position = Vector(self.actor.position.x, self.actor.position.y)
			barfee.tilePos = target.tilePos

			local movePos = board:toWorldPos(target.tilePos)
			
			--whats happening here?
			flux.to(
				barfee.position,
				0.3,
				{
					x = movePos.x,
					y = movePos.y
				}
			)
			:oncomplete(function()
				board.tiles[barfee.tilePos.y][barfee.tilePos.x].entity = barfee;
				board.tiles[barfee.tilePos.y][barfee.tilePos.x].color = barfee.color;
			end)

			flux.to(
				barfee,
				1,
				{
					width = TILE_SIZE * 0.6,
					height = TILE_SIZE * 0.6
				}
			)
			:ease("elasticout")
		end,
		undo = function(self)
		end 
	}
}