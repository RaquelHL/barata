local GameManager = {}

score = 0
local barata = nil

function GameManager.init(b)
	frScore = GUI:Frame({x = love.graphics.getWidth()-200, w = 200, h = 50, padding = 8, layout = "boxV", childHalign = "left"})
	lblScore = GUI:Label({text = "Score: ", color = Color(0)})
	frScore:addChild(lblScore)
	barata = b
end

function GameManager.draw()
	lblScore:setText("Score: "..score)
	GUI:draw(frScore)
end

function GameManager.addScore(s)
	score = score + s
end

function GameManager.getPlayer()
	return barata
end

return GameManager