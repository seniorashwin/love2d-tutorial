function love.load()
    camera = require 'libraries.camera'
    cam = camera()

    anim8 = require 'libraries.anim8'
    love.graphics.setDefaultFilter("nearest", "nearest")

    sti = require 'libraries.sti'
    gameMap = sti("maps/testMap.lua")

    player = {}
    player.x = 400
    player.y = 200
    player.speed = 200
    player.spriteSheet = love.graphics.newImage("sprites/player-sheet.png")
    player.grid = anim8.newGrid(12, 18, player.spriteSheet:getWidth(), player.spriteSheet:getHeight())

    player.animation = {}
    player.animation.down = anim8.newAnimation(player.grid('1-4', 1), 0.2)
    player.animation.left = anim8.newAnimation(player.grid('1-4', 2), 0.2)
    player.animation.right = anim8.newAnimation(player.grid('1-4', 3), 0.2)
    player.animation.up = anim8.newAnimation(player.grid('1-4', 4), 0.2)

    player.anim = player.animation.left

    background = {}
    background.sprite = love.graphics.newImage("sprites/background.png")
end

function love.update(dt)
    local isMoving = false
    if love.keyboard.isDown("left") then
        player.x = player.x - player.speed * dt
        player.anim = player.animation.left
        isMoving = true
    end

    if love.keyboard.isDown("right") then
        player.x = player.x + player.speed * dt
        player.anim = player.animation.right
        isMoving = true
    end

    if love.keyboard.isDown("up") then
        player.y = player.y - player.speed * dt
        player.anim = player.animation.up
        isMoving = true
    end

    if love.keyboard.isDown("down") then
        player.y = player.y + player.speed * dt
        player.anim = player.animation.down
        isMoving = true
    end

    if isMoving == false then
        player.anim:gotoFrame(2)
    end

    player.anim:update(dt)

    cam:lookAt(player.x, player.y)

    local w = love.graphics.getWidth()
    local h = love.graphics.getHeight()

    if player.x < w / 2 then
        player.x = w / 2
    end
    if player.y < h / 2 then
        player.y = h / 2
    end

    local mapW = gameMap.width * gameMap.tilewidth
    local mapH = gameMap.height * gameMap.tileheight

    -- Right border
    if player.x > mapW - w / 2 then
        player.x = mapW - w / 2
    end

    -- Bottom border
    if player.y > mapH - h / 2 then
        player.y = mapH - h / 2
    end
end

function love.draw()
    cam:attach()
    gameMap:drawLayer(gameMap.layers["Grass"])
    gameMap:drawLayer(gameMap.layers["Road"])
    gameMap:drawLayer(gameMap.layers["Trees"])
    player.anim:draw(player.spriteSheet, player.x, player.y, nil, 4, nil, 6, 9, 0)
    cam:detach()

    love.graphics.print("X: " .. tostring(player.x) .. " Y: " .. tostring(player.y), 10, 10)
end
