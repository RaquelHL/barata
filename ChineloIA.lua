--[[
	ChineloIA
]]
ChineloIA = {}
ChineloIA.__index = ChineloIA

local function new()
	local cia = {}
	setmetatable(cia, ChineloIA)	

	cia.isChineloIA = true
	cia.name = "enemy"

	cia.speed = 400

	return cia
end

function ChineloIA:init()
	self.barata = GameMgr.getPlayer()

	self.go.renderer.offsetX = 16
	self.go.renderer.offsetY = 16
	self.go.renderer.offsetOX = 16
	self.go.renderer.offsetOY = 32


end

function ChineloIA:update(dt)
	self.go.collider:updateRect(15,15)
	self.speedX = (math.sin(self.go.transform.o)) * self.speed * dt
    self.speedY = -(math.cos(self.go.transform.o)) * self.speed * dt
	local nX, nY, cols, n = physics:move(self.go, self.go.transform.x + self.speedX, self.go.transform.y + self.speedY, function(a, b)
		
			return "cross"
		
	end)

	for k,v in pairs(cols) do
		if v.other.motor then
			v.other.motor:die()
			self.go:destroy()
		end
	end
	
	self.go.transform:translate(nX, nY)
	if self.go.transform.x < -10 or self.go.transform.x > map.width*map.tilewidth + 1 
		or self.go.transform.y < -10 or self.go.transform.y > map.height*map.tileheight + 1 then
		self.go:destroy()
	end
end

function ChineloIA:clone()
	return new()
end

setmetatable(ChineloIA, {__call = function(_, ...) return new(...) end})