--[[
	PlayerInput: Controla o CharacterMotor com a entrada do jogador
]]
PlayerInput = {}
PlayerInput.__index = PlayerInput

local function new(...)
	local pi = {}
	setmetatable(pi, PlayerInput)	

	pi.isComponent = true
	pi.name = "input"

	--Lida com argumentos

	return pi
end

function PlayerInput:init()
	assert(self.go, self.name.." component has no GameObject")
	assert(self.go.motor, self.name.." needs a CharacterMotor component")
	
	self.motor = self.go.motor
end

function PlayerInput:update(dt)
	if(love.keyboard.isDown("left"))then
		self.motor:turn(-dt)
	end
	if(love.keyboard.isDown("right"))then
		self.motor:turn(dt)
	end
	if(love.keyboard.isDown("up"))then
		self.motor:move(1)	
	end
end

function PlayerInput:clone()
	return new()
end

setmetatable(PlayerInput, {__call = function(_, ...) return new(...) end})