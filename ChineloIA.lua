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

	cia.speed = 250

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
		if(b.food or b.enemy or b.motor) then
			return "cross"
		else 
			return "slide"
		end
	end)

	for k,v in pairs(cols) do
		if v.other.motor then
			v.other.motor:die()
		end
	end
	
	self.go.transform:translate(nX, nY)
end

function ChineloIA:clone()
	return new()
end

setmetatable(ChineloIA, {__call = function(_, ...) return new(...) end})