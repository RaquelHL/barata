local imagewidth = 290	
local imageheight = 74
local texture = love.graphics.newImage("textures/pizza.png")
return {
	{
		name = "pizza",
		texture = texture,
		size = 5,
		timestep = 0,
		loop = false,
		tilewidht = 58,
		tileheight = 74,
		frames = {
			{quad = love.graphics.newQuad(0, 0, 58, 74, imagewidth, imageheight)},
			{quad = love.graphics.newQuad(58, 0, 58, 74, imagewidth, imageheight)},
			{quad = love.graphics.newQuad(116, 0, 58, 74, imagewidth, imageheight)},
			{quad = love.graphics.newQuad(174, 0, 58, 74, imagewidth, imageheight)},
			{quad = love.graphics.newQuad(232, 0, 58, 74, imagewidth, imageheight)}
		}
	}
}