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

require("Color")
ResourceMgr = require("ResourceManager")
GameMgr = require("GameManager")

Timer = require("lib.hump.timer")
Camera = require("lib.hump.camera")
Gamestate = require("lib.hump.gamestate")

gui = require("lib.gui.gui")

require("menu")
require("game")

local pprintList = {}


function love.load()

	initResources()	

	GUI = gui()
	
	font = love.graphics.newFont("font/courbd.ttf", 24)
    GUI:newPanelType("button", buttonTex, 4, 56)

	love.window.setMode(1200, 800, {fullscreen = true, vsync = false})
    Gamestate.registerEvents()
	Gamestate.switch(menu)
end

function love.update(dt)
	Timer.update(dt)
end

function initResources()
	tileTex = ResourceMgr.get("texture", "ladrilho.png")
	foodParticle = ResourceMgr.get("texture", "foodParticle.png")
	foodTex = ResourceMgr.get("texture", "pizza.png")
	broomTex = ResourceMgr.get("texture", "vassoura2.png")
	chineloTex = ResourceMgr.get("texture", "chinelo.png")

	buttonTex = ResourceMgr.get("texture", "button.png")

	ResourceMgr.add("animsheet", "barataSheet2")
	ResourceMgr.add("animsheet", "foodAnim")
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