--[[
	CharacterMotor: Controla a barata
]]

CharacterMotor = {}
CharacterMotor.__index = CharacterMotor

local function new()
	local cm = {}
	setmetatable(cm, CharacterMotor)	

	cm.isComponent = true
	cm.name = "motor"


	cm.isAlive = true
	cm.maxLife = 3
	cm.life = cm.maxLife
	cm.maxSpeed = 375
	cm.accSpeed = 100
	cm.turnSpeed = 5

	cm.fwdSpeed = 0
	cm.speedX = 0
	cm.speedY = 0

	return cm
end

function CharacterMotor:init()
	assert(self.go, self.name.." component has no GameObject")
	assert(self.go.collider, self.name.." needs a collider component")

	barataTex = ResourceMgr.get("texture", "barata.png")
	barataOutlineTex = ResourceMgr.get("texture", "barataOutline.png")
end

function CharacterMotor:update(dt)
	if not self.isAlive then
		return
	end
	self.speedX = (math.sin(self.go.transform.o)) * self.fwdSpeed * dt
    self.speedY = -(math.cos(self.go.transform.o)) * self.fwdSpeed * dt
	local nX, nY, cols, n = physics:move(self.go, self.go.transform.x + self.speedX, self.go.transform.y + self.speedY, function(a, b)
		if(b.food or b.enemy) then
			return "cross"
		else
			return "slide"
		end
	end)

	local eating = false
	for k,v in pairs(cols) do
		if v.other.food  and not eating and self.fwdSpeed == 0 then
			eating = true
			if(v.other.food:eat(dt)) then
			 	GameMgr.addScore(10)
			 end
		end
	end

	if(eating) then
		self.go.particle:start()
	else
		self.go.particle:stop()
	end
	
	self.go.transform:translate(nX, nY)

	self.fwdSpeed = self.fwdSpeed * 0.5
	if(self.fwdSpeed<10)then
		self.fwdSpeed = 0
		self.go.animator:setAnim("idle")
	else
		if (self.go.animator.anim.name ~= "walk") then
			self.go.animator:setAnim("walk")
		end
	end

	pprint("fwdSpeed = "..self.fwdSpeed)
	pprint("speedX = "..self.speedX)
	pprint("speedY = "..self.speedY)
end

function CharacterMotor:draw()
	for i=1,self.maxLife do
		if i <= self.life then
			love.graphics.draw(barataTex, 10 + ((i-1) * barataTex:getWidth()+10), 10)
		else
			love.graphics.draw(barataOutlineTex, 10 + ((i-1) * barataTex:getWidth()+10), 10)
		end
	end
end

function CharacterMotor:turn(dir)
	if not self.isAlive then
		return
	end
	self.go.transform.o = self.go.transform.o + (dir * self.turnSpeed)
end

function CharacterMotor:move(dir)
	if not self.isAlive then
		return
	end
	self.fwdSpeed = math.min(self.fwdSpeed + (dir * self.accSpeed), self.maxSpeed)
end

function CharacterMotor:die()
	self.life = self.life - 1
	if self.life <= 0 then
		self.go.animator:setAnim("die")
		self.go.particle:stop()
		self.isAlive = false

	end
end

function CharacterMotor:clone()
	return new()
end

setmetatable(CharacterMotor, {__call = function(_, ...) return new(...) end})