--[[
	Scene: 
	-> Responsável por manter e gerenciar todos os gameObjects
	-> Chama as funções draw e update dos gameObjects
]]

Scene = {}
Scene.__index = Scene

local function new()
	local s = {}
	setmetatable(s, Scene)

	s.gameObjects = {}

	return s
end

function Scene:update(dt)
	for k,go in pairs(self.gameObjects) do
		if not go.toDestroy then
			go:update(dt)
		end
	end
end

function Scene:draw()
	for k,go in pairs(self.gameObjects) do
		if not go.toDestroy then
			go:draw()
		end
	end
end

function Scene:addGO(go)
	assert(go.isInstance, "GameObject needs to be an instance")
	go.scene = self
	self.gameObjects[#self.gameObjects+1] = go

end

function Scene:loadMap(name)
	map = require("maps."..name)
	if(map.backgroundcolor) then
		love.graphics.setBackgroundColor(map.backgroundcolor)
	end
	--love.window.setMode(map.width*map.tilewidth, map.height*map.tileheight, flags)
	map.tiles = {}

	for i,ts in ipairs(map.tilesets) do
		ts.texture = ResourceMgr.get("tileset", ts.image)
		local curID = ts.firstgid
		ts.lastid = curID + ts.tilecount
		for j=0, (ts.imageheight/ts.tileheight)-1 do
			for i=0, (ts.imagewidth/ts.tilewidth)-1 do
				map.tiles[curID] = {}
				map.tiles[curID].quad = love.graphics.newQuad(i*ts.tilewidth, j*ts.tileheight, ts.tilewidth, ts.tileheight, ts.imagewidth, ts.imageheight)
				curID = curID + 1
			end
		end

		for k,t in pairs(ts.tiles) do
			for k,p in pairs(t.properties) do
				map.tiles[t.id+1][k] = p
			end
		end
	end

	local function getTileSet(id)
		for i,ts in ipairs(map.tilesets) do
			if (id>=ts.firstgid and id < ts.lastid) then
				return i
			end
		end
		return 0
	end

	for k,l in pairs(map.layers) do
		if (l.type == "tilelayer") then 	--Estatico, nunca muda. Poe tudo num spriteBatch em um gameObject
			local layerGO = GameObject(l.name)	 
			local batchs = {}	--Precisa de um spritebatch para cada tileset
		    local curTile = 1

		    --Pra não criar um collider por tile, detecta os tiles adjacentes pra criar um collider só

		    local colX = 0	
		    local colY = 0
		    local colW = 0
		    local colCount = 0
		    print("criando camada "..l.name)
		    for j=0,map.height-1 do
		    	for i=0,map.width-1 do
		    		local closeCollider = false
		    		if(l.data[curTile] ~= 0) then
			    		local tsID = getTileSet(l.data[curTile])
			    		if not batchs[tsID] then 	--Só cria um batch pro tileset se ele for usado
			    			batchs[tsID] = love.graphics.newSpriteBatch(map.tilesets[tsID].texture, map.width * map.height, "static")
			    		end
			    		batchs[tsID]:add(map.tiles[l.data[curTile]].quad, i*map.tilewidth, j*map.tileheight)

			    		--Trata da criação do boxCollider

			    		if(l.properties.collision) then
			    			if(map.tiles[l.data[curTile]].isSlope) then
			    				local colliderGO = GameObject("col"..colCount, {BoxCollider(map.tilewidth, map.tileheight)})
				    			colliderGO.transform.x = i*map.tilewidth
				    			colliderGO.transform.y = j*map.tileheight
				    			
				    			colliderGO.collider.isSlope = true	
				    			colliderGO.collider.rightY = map.tiles[l.data[curTile]].rightY
				    			colliderGO.collider.leftY = map.tiles[l.data[curTile]].leftY

				    			layerGO:addChild(colliderGO)
				    			colCount = colCount + 1

				    			closeCollider = true
			    			else
					    		if(colW==0)then
					    			colX = i*map.tilewidth
					    			colY = j*map.tileheight
					    		end
					    		colW = colW + 1
					    	end

				    	end
			    	end


			    	--Se tiver um tile vazio ou acabou o mapa, e os tiles anteriores tinham colisão, fecha um collider
			    	nextTile = math.min(curTile+1, map.width*map.height-1)

			    	if ((l.data[curTile] == 0 or i == (map.width-1) or closeCollider) and l.properties.collision and colW>0) then
		    			colCount = colCount + 1
		    			local colliderGO = GameObject("col"..colCount, {BoxCollider(colW*map.tilewidth, map.tileheight)})
		    			colliderGO.transform.x = colX
		    			colliderGO.transform.y = colY
		    			colliderGO.tileID = l.data[curTile]
		    			if(l.data[curTile] == 21)then
		    				colliderGO.isSlope = true	
		    			end
		    			layerGO:addChild(colliderGO)

		    			colW = 0
		    		
			    	end
			    	curTile = curTile + 1
		    	end
		    end

		    for i,b in ipairs(batchs) do
		    	local tsGO = GameObject("tileset "..i, {Renderer(b)})
		    	layerGO:addChild(tsGO)
		    end

		    self:addGO(layerGO:newInstance())

		end
		if (l.type == "objectgroup") then
			if(l.name == "obstacles")then
				for k,v in pairs(l.objects) do
					local obj = GameObject(v.name.."("..v.id..")", {Renderer(map.tilesets[getTileSet(v.gid)].texture)})
					obj.renderer.quad = map.tiles[v.gid]
					v.rad = math.rad(v.rotation)
					local cW, cH, cX, cY = v.width, v.height, 0, 0
					if(v.rotation == 90) then
						cX = -v.height
						cW = v.height
						cH = v.width
					end
					if(v.rotation == 180) then
						cX = -v.width
						cY = -v.height
					end
					if(v.rotation == 270) then
						cY = -v.width
						cW = v.height
						cH = v.width
					end
					obj:addComponent(BoxCollider(cW*0.9, cH*0.9, cX + cW*0.05, cY + cH * 0.05))
					self:addGO(obj:newInstance({x = v.x, y = v.y, o = v.rad}))
				end
			end
			if(l.name == "player") then
				barata = GameObject("barata", {Renderer(), SpriteAnimator("walk"), BoxCollider(24,24), CharacterMotor(), PlayerInput(), Particle(foodParticle, 16, 16)}):newInstance({x = l.objects[1].x, y = l.objects[1].y, sx = 0.5, sy = 0.5})

				barata.renderer.offsetX = 12
				barata.renderer.offsetY = 12
				barata.renderer.offsetOX = 32
				barata.renderer.offsetOY = 32
				
				barata.particle.ParticleSystem:setColors(255,0,0, 255, 255, 0, 0, 0)
				barata.particle.ParticleSystem:setEmitterLifetime(0.5)
				barata.particle.ParticleSystem:setAreaSpread("normal", 2, 2)

				barata.particle:stop()

				GameMgr.init(barata)

				self:addGO(barata)
			end
			if(l.name == "food") then
				local pizza = GameObject("pizza", {Renderer(), SpriteAnimator("pizza"), BoxCollider(88, 114, -10, -20), Food(3), Particle(foodParticle, 29, 37)})
				local maca = GameObject("maca", {Renderer(), SpriteAnimator("maca"), BoxCollider(60, 87, -15, -20), Food(2), Particle(foodParticle, 15, 22)})

				for k,v in pairs(l.objects) do
					if (map.tilesets[getTileSet(v.gid)].name == "pizza") then
						local pizzaI = pizza:newInstance({x = v.x, y = v.y})
						self:addGO(pizzaI)		
						pizzaI.particle.ParticleSystem:setAreaSpread("normal", 10, 10)
					else 
						if(map.tilesets[getTileSet(v.gid)].name == "maca") then
							local macaI = maca:newInstance({x = v.x, y = v.y})
							self:addGO(macaI)
							macaI.particle.ParticleSystem:setAreaSpread("normal", 10, 10)
						end
					end
				end
				
			end

			if(l.name == "vassouras") then
				broom = GameObject("v", {Renderer(broomTex), BoxCollider(50,50), BroomIA()})
				for k,v in pairs(l.objects) do
					self:addGO(broom:newInstance({x = v.x, y = v.y, sy = 0.5}))
				end
			end
		end
	end
	return map
end

setmetatable(Scene, {__call = function(_, ...) return new(...) end})