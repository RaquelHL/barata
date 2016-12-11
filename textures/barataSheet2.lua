local imagewidth = 256
local imageheight = 64
local texture = love.graphics.newImage("textures/barataSheet2.png")
return {
	{
		name = "idle",
		texture = texture,
		size = 1,
		timestep = 0.1,
		loop = true,
		tilewidht = 64,
		tileheight = 64,
		frames = {
			{quad = love.graphics.newQuad(0, 0, 64, 64, imagewidth, imageheight)}
		}
	},
	{
		name = "walk",
		texture = texture,
		size = 4,
		timestep = 0.1,
		loop = true,
		tilewidht = 64,
		tileheight = 64,
		frames = {
			{quad = love.graphics.newQuad(64, 0, 64, 64, imagewidth, imageheight)},
			{quad = love.graphics.newQuad(0, 0, 64, 64, imagewidth, imageheight)},
			{quad = love.graphics.newQuad(128, 0, 64, 64, imagewidth, imageheight)},
			{quad = love.graphics.newQuad(0, 0, 64, 64, imagewidth, imageheight)}
		}
	},
	{
		name = "die",
		texture = texture,
		size = 1,
		timestep = 0.1,
		loop = true,
		tilewidht = 64,
		tileheight = 64,
		frames = {
			{quad = love.graphics.newQuad(192, 0, 64, 64, imagewidth, imageheight)}
		}
	}
}