--[[
	BroomIA: Controla a vassoura
]]
BroomIA = {}
BroomIA.__index = BroomIA

local function new(...)
	local bia = {}
	setmetatable(bia, BroomIA)	

	bia.isComponent = true
	bia.name = "enemy"

	bia.reach = 256

	bia.cooldown = 3	--Segundos entre ataques
	bia.lastAttack = love.timer.getTime()	

	bia.isAttacking = false

	return bia
end

function BroomIA:init()
	self.barata = GameMgr.getPlayer()
	
	self.go.renderer.offsetOX = 37
end

function BroomIA:update(dt)
	self:updateCollider()
	self.barataDist = dist(self.go.transform.x,self.go.transform.y,self.barata.transform.x,self.barata.transform.y)
	if not self.isAttacking then
		self.go.transform.o = -math.atan2(self.barata.transform.x - self.go.transform.x, self.barata.transform.y - self.go.transform.y)
	end
	if (love.timer.getTime() - self.lastAttack > self.cooldown) and (self.barataDist < self.reach) then
		self:attack()
	end
end

function BroomIA:attack()
	self.isAttacking = true
	Timer.tween(0.2, self.go.transform, {sy = self.barataDist/self.reach}, "in-cubic", function()
		Timer.tween(0.5, self.go.transform, {sy = 0.5}, "out-quad", function()
			self.isAttacking = false
		end)
		self:updateCollider()
		local actualX, actualY, cols, len = physics:check(self.go)
		for k,v in pairs(cols) do
			if(v.other == self.barata)then
				self.barata.motor.isAlive = false
				pprint("morreu","a")
			end
		end
	end)
	self.lastAttack  = love.timer.getTime()
end

function BroomIA:updateCollider()
	local colY = math.cos(self.go.transform.o) * self.go.transform.sy * self.go.renderer.texture:getHeight()-25
	local colX = -math.sin(self.go.transform.o) * self.go.transform.sy * self.go.renderer.texture:getHeight()-25
	self.go.collider:updateRect(colX,colY)
end

function BroomIA:clone()
	return new()
end

setmetatable(BroomIA, {__call = function(_, ...) return new(...) end})