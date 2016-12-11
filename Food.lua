--[[
	Food: 
]]
Food = {}
Food.__index = Food

local function new(time)
	local f = {}
	setmetatable(f, Food)

	f.isComponent = true
	f.name = "food"


	f.timeToEat = time or 1
	f.timeEaten = 0
	--Lida com argumentos

	return f
end

function Food:init()

end

function Food:update(dt)
	if(self.go.animator)then
		self.go.animator:gotoFrame(math.floor(self.timeEaten / self.timeToEat * self.go.animator.anim.size)+1)
		--self.go.animator:gotoFrame(2)
	else
		if(self.timeEaten>0)then
			self.go.transform.sx = 1 - self.timeEaten / self.timeToEat
			self.go.transform.sy = 1 - self.timeEaten / self.timeToEat
		end
	end
end

function Food:eat(t)
	self.timeEaten = self.timeEaten + t
	if(self.timeEaten >= self.timeToEat)then
		self.go:destroy()
		return true
	end
	return false
end

function Food:clone()
	return new()
end

setmetatable(Food, {__call = function(_, ...) return new(...) end})