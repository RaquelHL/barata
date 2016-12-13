
local bump = require("lib.bump")
local bumpdebug = require("lib.bump_debug")

game = {}

function game:enter()
	physics = bump.newWorld(168)	--Tem que colocar isso em algum outro lugar	
	chinelo = GameObject("c", {ChineloLauncher()})

	testScene = Scene()
	map = testScene:loadMap("level1")	
	testScene:addGO(chinelo:newInstance({x = 200, y = 200, o = 2}))

	barata = GameMgr:getPlayer()

	camera = Camera(barata.transform.x, barata.transform.y)

	gameover = false

	frGameover = GUI:Frame({x = love.graphics.getWidth()/2 - 150, y = love.graphics.getHeight()/2 - 200, w = 300, h =400, panelType = "button", color = Color(200), layout = "boxV", childHalign = "center"})
	frGameover:addChild(GUI:Label({text = "Game Over", color = Color(0)}))
	lblScore2 = GUI:Label({text = "Score:        "..score, color = Color(0)})
	frGameover:addChild(lblScore2)

	frGameover:addChild(GUI:Button({text ="Try again", callback = function()
		score = 0
		Gamestate.switch(game)
	end}))

    
end

function game:update(dt)
	testScene:update(dt)
	local dx,dy = barata.transform.x, barata.transform.y

    camera:lookAt(math.floor(math.max(math.min(dx, map.width*map.tilewidth - (love.graphics.getWidth()*1/camera.scale)/2), (love.graphics.getWidth()*1/camera.scale)/2)),
    			math.floor(math.max(math.min(dy, map.height*map.tileheight - (love.graphics.getHeight()*1/camera.scale)/2), (love.graphics.getHeight()*1/camera.scale)/2)))
    local cx, cy = camera:position()
end

function game:draw()
	camera:attach()
	testScene:draw()

	--bumpdebug.draw(physics)
	camera:detach()
	GameMgr.draw()

	if gameover then
		GUI:draw(frGameover)
	end

	--pprintDraw()
end


function game:mousepressed(x,y,b)
    GUI:mousepressed(frGameover, x, y, b)
end
