
local bump = require("lib.bump")
local bumpdebug = require("lib.bump_debug")

game = {}

function game:init()
	physics = bump.newWorld(168)	--Tem que colocar isso em algum outro lugar	
	chinelo = GameObject("c", {ChineloLauncher()})

	testScene = Scene()
	map = testScene:loadMap("level1")	
	testScene:addGO(chinelo:newInstance({x = 200, y = 200, o = 2}))

	barata = GameMgr:getPlayer()

	camera = Camera(barata.transform.x, barata.transform.y)

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
	pprintDraw()
end