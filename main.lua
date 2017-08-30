local scenario = require "map/scenario"
local config = require "config"
local character = require "character/graphics"

function checkSetas()
  return love.keyboard.isDown("right") or love.keyboard.isDown("left") or love.keyboard.isDown("down") or love.keyboard.isDown("up")
end

function movePlayer(dt)
  if player.targetx < 1 then
    player.targetx = 1
  elseif player.targety < 1 then
    player.targety = 1
  elseif player.targetx > world.sizex then
    player.targetx = world.sizex
  elseif player.targety > world.sizey then
    player.targety = world.sizey
  elseif (world.map[player.targetx][player.targety].box%3) ~= 0 and world.map[player.targetx][player.targety].box >= 0 then
    player.targetx = player.sqmx
    player.targety = player.sqmy
  elseif player.targetx ~= player.sqmx then
    player.moving = true
    player.offsetx = player.offsetx + (((player.targetx - player.sqmx)/(math.abs(player.targetx - player.sqmx))) * 100 * dt)
    player.idleTimer = 0
    if not checkSetas() then
      if player.targetx - player.sqmx > 0 then
        player.dir = 3
      else
        player.dir = 1
      end
    end
    player.frame_timer = player.frame_timer + dt
    character.changeFrame(player, global.frame_timer)
  elseif player.targety ~= player.sqmy then
    player.moving = true
    player.offsety = player.offsety + (((player.targety - player.sqmy)/(math.abs(player.targety - player.sqmy))) * 100 * dt)
    player.idleTimer = 0
    if not checkSetas() then
      if player.targety - player.sqmy > 0 then
        player.dir = 0
      else player.dir = 2
      end
    end
    player.frame_timer = player.frame_timer + dt
    character.changeFrame(player, global.frame_timer)
  end
  if player.offsetx >= 32 then
    player.sqmx = player.sqmx + math.floor(player.offsetx/32)
    player.offsetx = 0
    player.moving = false
  elseif player.offsetx <= -32 then
    player.sqmx = player.sqmx + math.ceil(player.offsetx/32)
    player.offsetx = 0
    player.moving = false
  end
  if player.offsety >= 32 then
    player.sqmy = player.sqmy + math.floor(player.offsety/32)
    player.offsety = 0
    player.moving = false
  elseif player.offsety <= -32 then
    player.sqmy = player.sqmy + math.ceil(player.offsety/32)
    player.offsety = 0
    player.moving = false
  end
end

function love.load()
  
  global = config.load()
  
  love.window.setTitle(global.title)
  love.window.setMode(global.sizex, global.sizey, {resizable=false})
  
  map = {
    image = love.graphics.newImage("map/tileset2.png"),
    Quads = {},
  }
  
  world = {
    sizex = math.ceil(global.sizex/32),
    sizey = math.ceil(global.sizey/32)-1,
    diff = 0,
  }
  
  player = {
    charQuads = {},
    charImage = love.graphics.newImage("character/character.png"),
    sqmx = 1,
    sqmy = 1,
    targetx = 1,
    targety = 1,
    offsetx = 0,
    offsety = 0,
    dir = 0,
    frame = 1,
    frame_timer = 0,
    walk_delay = 0,
    idleTimer = 0,
    moving = false,
  }
  
  mouse = {
    x = love.mouse.getX(),
    y = love.mouse.getY(),
    i = 0,
    j = 0,
  }
  
  scenario.create(world)
  
  character.load(player)
  scenario.load(map)
end

function love.update(dt)
  movePlayer(dt)
  player.walk_delay = player.walk_delay + dt
  player.idleTimer = player.idleTimer + dt
  scenario.checkWin(world, player)
  
  mouse.x = love.mouse.getX()
  mouse.y = love.mouse.getY()
  mouse.i = math.floor(mouse.x/32)
  mouse.j = math.floor(mouse.y/32)
  
  if player.idleTimer > 0.05 and player.frame ~= player.dir*5+1 then
    player.frame = player.dir*5+1
  end
  
  if love.keyboard.isDown("up") then
    if player.dir ~= 2 then
      player.dir = 2
      character.changeFrame(player, global.frame_timer)
    end
  elseif love.keyboard.isDown("down") then
    if player.dir ~= 0 then
      player.dir = 0
      character.changeFrame(player, global.frame_timer)
    end
  elseif love.keyboard.isDown("left") then
    if player.dir ~= 1 then
      player.dir = 1
      character.changeFrame(player, global.frame_timer)
    end
  elseif love.keyboard.isDown("right") then
    if player.dir ~= 3 then
      player.dir = 3
      character.changeFrame(player, global.frame_timer)
    end
  end
  if not player.moving then
    if love.keyboard.isDown("w")then
      if player.walk_delay > global.walk_delay then
        player.targety = player.targety - 1
        player.walk_delay = 0
      end
    elseif love.keyboard.isDown("s")then
      if player.walk_delay > global.walk_delay then
        player.targety = player.targety + 1
        player.walk_delay = 0
      end
    elseif love.keyboard.isDown("a") then
      if player.walk_delay > global.walk_delay then
        player.targetx = player.targetx - 1
        player.walk_delay = 0
      end
    elseif love.keyboard.isDown("d") then
      if player.walk_delay > global.walk_delay then
        player.targetx = player.targetx + 1
        player.walk_delay = 0
      end
    end
  end
end

function love.draw()
  love.graphics.setColor(255,255,255)
  for i=1, world.sizex, 1 do
    for j=1, world.sizey, 1 do
      if world.map[i][j].box == -1 then
        love.graphics.draw(map.image, map.Quads[7], (i-1)*32+world.map[i][j].offsetx, (j)*32+world.map[i][j].offsety)
        --love.graphics.print("".. ((player.targetx - player.sqmx)/(math.abs(player.targetx - player.sqmx))) .."", (i-1)*32+world.map[i][j].offsetx, (j-1)*32+world.map[i][j].offsety)
      elseif (world.map[i][j].box%3) == 1 then
        love.graphics.draw(map.image, map.Quads[8], (i-1)*32, (j)*32)
      elseif (world.map[i][j].box%3) == 2 then
        love.graphics.draw(map.image, map.Quads[7], (i-1)*32, (j)*32)
      end
    end
  end
  if mouse.i >= 0 and mouse.i <= world.sizex and mouse.j > 0 and mouse.j <= world.sizey then
    love.graphics.setColor(255,0,0)
    love.graphics.rectangle("line", mouse.i*32, mouse.j*32, 32, 32)
  end
  love.graphics.setColor(255,255,255)
  love.graphics.print("Level: " .. world.diff .. " mouse.i: " .. mouse.i .. " mouse.j: " .. mouse.j .. "", 0, 0)
  love.graphics.line(0,32,global.sizex,32)
  love.graphics.draw(player.charImage, player.charQuads[player.frame], (player.sqmx-1)*32 + player.offsetx, (player.sqmy) * 32 + player.offsety)
  love.graphics.setColor(255,0,0)
end