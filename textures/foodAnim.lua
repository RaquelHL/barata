local texturePizza = love.graphics.newImage("textures/pizza.png")
local textureMaca = love.graphics.newImage("textures/maca.png")
return {
	{
		name = "pizza",
		texture = texturePizza,
		size = 5,
		timestep = 0,
		loop = false,
		tilewidht = 58,
		tileheight = 74,
		frames = {
			{quad = love.graphics.newQuad(0, 0, 58, 74, 290, 74)},
			{quad = love.graphics.newQuad(58, 0, 58, 74, 290, 74)},
			{quad = love.graphics.newQuad(116, 0, 58, 74, 290, 74)},
			{quad = love.graphics.newQuad(174, 0, 58, 74, 290, 74)},
			{quad = love.graphics.newQuad(232, 0, 58, 74, 290, 74)}
		}
	},
	{
		name = "maca",
		texture = textureMaca,
		size = 5,
		timestep = 0,
		loop = false,
		tilewidht = 30,
		tileheight = 47,
		frames = {
			{quad = love.graphics.newQuad(0, 0, 30, 47, 150, 47)},
			{quad = love.graphics.newQuad(30, 0, 30, 47, 150, 47)},
			{quad = love.graphics.newQuad(60, 0, 30, 47, 150, 47)},
			{quad = love.graphics.newQuad(90, 0, 30, 47, 150, 47)},
			{quad = love.graphics.newQuad(120, 0, 30, 47, 150, 47)}
		}
	}
}