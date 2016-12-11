--[[
	ChineloLauncher: Instancia chinelos
]]
ChineloLauncher = {}
ChineloLauncher.__index = ChineloLauncher

local function new(...)
	local cl = {}
	setmetatable(cl, ChineloLauncher)

	cl.isChineloLauncher = true
	cl.name = "chineloLauncher"

	cl.freq = 0.8
	cl.lastChinelo = love.timer.getTime()

	return cl
end

function ChineloLauncher:init()
	self.chineloGO = GameObject("chinelo", {Renderer(chineloTex), BoxCollider(30,30), ChineloIA()})
end

function ChineloLauncher:update(dt)
	if(love.timer.getTime() - self.lastChinelo > self.freq) then
		self.go.scene:addGO(self:newChinelo())
		self.lastChinelo = love.timer.getTime()
	end
end

function ChineloLauncher:newChinelo()
	local r = math.floor(love.math.random()*4)
	local x = 0
	local y = 0
	local o = 1.57
	if r == 0 then
		x = love.math.random() * love.graphics.getWidth()
		y = 0
		o = love.math.random() * math.pi + 1.57
		else if r == 1 then
			x = love.graphics.getWidth()
			y = love.math.random() * love.graphics.getHeight()
			o = love.math.random() * math.pi + math.pi
			else if r == 2 then
				x = love.math.random() * love.graphics.getWidth()
				y = love.graphics.getHeight()
				o = love.math.random() * math.pi - 1.57
				else if r == 3 then
					x = 0
					y = love.math.random() * love.graphics.getHeight()
					o = love.math.random() * math.pi
				end
			end
		end
	end
	return self.chineloGO:newInstance({x = x, y = y, o = o})
end

function ChineloLauncher:clone()
	return new()
end

setmetatable(ChineloLauncher, {__call = function(_, ...) return new(...) end})