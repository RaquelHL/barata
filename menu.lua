menu = {}

function menu:init()
	
	love.graphics.setBackgroundColor(Color(120):value())
    love.graphics.setFont(font)


    local numTilesX =  love.graphics.getWidth() / tileTex:getWidth() * 2
    local numTilesY =  love.graphics.getHeight() / tileTex:getHeight() * 2
    menuBgBatch = love.graphics.newSpriteBatch(tileTex, numTiles, "static")
    for i=0,numTilesX do
        for j=0,numTilesY do
            sPosX = i*tileTex:getWidth()/2
            sPosY = j*tileTex:getHeight()/2
            menuBgBatch:add(sPosX,sPosY,0,0.5,0.5)
        end
    end

    pnMenu = GUI:Frame({x = love.graphics.getWidth()/2-150, y = love.graphics.getHeight()/2-300, w = 300, h = 400, padding = 16, layout = "boxV", panelType = "button", color = Color(200,200,200,100)})

    pnMenu:addChild(GUI:Label({text = "Barata", color = Color(0)}))
    
    pnMenu:addChild(GUI:Button({text = "Play", w = 224, h = 64, callback = btJogarClick, color = Color(50, 50, 200), hoverColor = Color(80, 80, 250)}))
    pnMenu:addChild(GUI:Button({text = "Exit", w = 224, h = 64, callback = btSairClick, color = Color(50, 50, 200), hoverColor = Color(80, 80, 250)}))
end

function btJogarClick(b)
    Gamestate.switch(game)
end

function btSairClick(b)
    love.event.quit()
end


function menu:draw()
    love.graphics.setColor(255,255,255)
    love.graphics.draw(menuBgBatch)

    GUI:draw(pnMenu)
end

function menu:mousepressed(x,y,b)
    GUI:mousepressed(pnMenu, x, y, b)
end


function menu:keypressed(k)
    if(k=="return") then
        Gamestate.switch(game)
	end
end
