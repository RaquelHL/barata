--[[
	Food: 
]]
Food = {}
Food.__index = Food

local function new(...)
	local f = {}
	setmetatable(f, Food)

	f.isComponent = true
	f.name = "food"

	--Lida com argumentos

	return f
end

function Food:init()

end

function Food:update(dt)

end

function Food:clone()
	return new()
end

setmetatable(Food, {__call = function(_, ...) return new(...) end})