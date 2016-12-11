--Principais
require("GameObject")
require("Scene")

--Componentes
require("Transform")
require("Renderer")
require("BoxCollider")
require("SpriteAnimator")
require("PlayerInput")
require("CharacterMotor")
require("Particle")

require("Food")
require("BroomIA")
require("ChineloIA")
require("ChineloLauncher")

--Outros
require("Color")
ResourceMgr = require("ResourceManager")
GameMgr = require("GameManager")

local bump = require("lib.bump")
local bumpdebug = require("lib.bump_debug")
Timer = require("lib.hump.timer")
Camera = require "lib.hump.camera"

gui = require("lib.gui.gui")

local pprintList = {}

function love.load()

	physics = bump.newWorld(168)	--Tem que colocar isso em algum outro lugar	
	initExtraPhysics()
	initResources()	

	GUI = gui()
	font = love.graphics.getFont()

	

	chinelo = GameObject("c", {ChineloLauncher()})

	testScene = Scene()
	map = testScene:loadMap("level1")	
	testScene:addGO(chinelo:newInstance({x = 200, y = 200, o = 2}))

	barata = GameMgr:getPlayer()

	camera = Camera(barata.transform.x, barata.transform.y)


	love.window.setMode(1200, 800, {fullscreen = true, vsync = false})

end

function love.update(dt)
	testScene:update(dt)
	Timer.update(dt)
	local dx,dy = barata.transform.x, barata.transform.y

    camera:lookAt(math.floor(math.max(math.min(dx, map.width*map.tilewidth - (love.graphics.getWidth()*1/camera.scale)/2), (love.graphics.getWidth()*1/camera.scale)/2)),
    			math.floor(math.max(math.min(dy, map.height*map.tileheight - (love.graphics.getHeight()*1/camera.scale)/2), (love.graphics.getHeight()*1/camera.scale)/2)))
    local cx, cy = camera:position()
    pprint(cx..", "..math.abs(math.max(math.min(dx, map.width*map.tilewidth - love.graphics.getWidth()/2), love.graphics.getWidth()/2)))
    pprint(cy)
end

function love.draw()
	camera:attach()
	testScene:draw()

	bumpdebug.draw(physics)
	camera:detach()
	GameMgr.draw()

	pprintDraw()
end

function initResources()
	tileTex = ResourceMgr.get("texture", "ladrilho2.png")
	foodParticle = ResourceMgr.get("texture", "foodParticle.png")
	foodTex = ResourceMgr.get("texture", "pizza.png")
	broomTex = ResourceMgr.get("texture", "vassoura2.png")
	chineloTex = ResourceMgr.get("texture", "chinelo.png")

	ResourceMgr.add("animsheet", "barataSheet2")
	ResourceMgr.add("animsheet", "foodAnim")
end

function initExtraPhysics()	--Achar um lugar pra por isso
	local oneway = function(world, col, x,y,w,h, goalX, goalY, filter)
  		local cols, len = world:project(col.item, x,y,w,h, goalX, goalY, filter)
		return goalX, math.min(goalY,col.item.transform.y), cols, len
	end
	local slope = function(world, col, x,y,w,h, goalX, goalY, filter)

		col.normal = {x = 0, y = 0}	--Até provado o contrario, não teve realmente uma colisão
  		local range = math.abs(col.other.collider.rightY-col.other.collider.leftY)

  		local charBase = math.min(math.max(col.item.transform.x + col.item.collider.w/2,col.other.transform.x), col.other.transform.x + col.other.collider.w)
  		local xNormal = (charBase - col.other.transform.x) / col.other.collider.w
  		if (col.other.collider.rightY < col.other.collider.leftY) then
  			xNormal = 1 - xNormal
  		end
  		local slopeY = (col.other.transform.y+col.other.collider.h) - ((xNormal * range) * col.other.collider.h) - math.min(col.other.collider.rightY, col.other.collider.leftY) * col.other.collider.h
  		slopeY = slopeY - col.item.collider.h
		if (goalY>slopeY) then
			col.normal = {x = 0, y = -1}	--Foi provado o contrario, teve colisão
		end

		return goalX, math.min(goalY,slopeY), {}, 0
	end

	physics:addResponse("slope", slope)

end

function love.keypressed(key)
	if key == "escape" then
		love.event.quit()
	end
end

function dist(x1, y1, x2, y2)
	return math.sqrt((x1-x2)*(x1-x2) + (y1-y2)*(y1-y2))
end

--Print para depurar valores contínuos
function pprint(text, name)
	if name then
		pprintList[name] = text
	else
		pprintList[#pprintList+1] = text
	end
end

function pprintDraw()
	love.graphics.setColor(0, 0, 0)
	local j = 0
	for i,v in ipairs(pprintList) do
		love.graphics.print(v, 10,50+ j*10)
		pprintList[i] = nil
		j = j + 1
	end
	for k,v in pairs(pprintList) do
		love.graphics.print(v, 10,50+ j*10)
		j = j + 1
	end
end