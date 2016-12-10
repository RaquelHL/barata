local GameManager = {}

local score = 0


function GameManager.init()
	frScore = GUI:Frame({x = love.graphics.getWidth()-100, w = 100, h = 50, padding = 8, layout = "boxV", childHalign = "left"})
	lblScore = GUI:Label({text = "Score: "})
	frScore:addChild(lblScore)
end

function GameManager.draw()
	lblScore:setText("Score: "..score)
	GUI:draw(frScore)
end

function GameManager.addScore(s)
	score = score + s
end



return GameManager