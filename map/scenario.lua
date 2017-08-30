local scenario = {}

function scenario.load(map)
  local count = 1
  for j = 0, 2, 1 do
    for i = 0, 2, 1 do
      map.Quads[count]=love.graphics.newQuad(i * 32, j * 32, 32, 32, map.image:getWidth(),map.image:getHeight())
      count = count + 1
    end
  end
end

function scenario.create(world)
  world.map = {}
  for i=1, world.sizex, 1 do
    world.map[i] = {}
    for j=1, world.sizey, 1 do
      world.map[i][j] = {box = love.math.random(0,4), x=i, y=j, offsetx=0, offsety=0}
      if world.map[i][j].box > 1 then
        world.map[i][j].box = 0
      end
    end
  end
  world.map[1][1].box = 0
  world.map[1][2].box = 0
  world.map[2][1].box = 0
end

function scenario.remake(world)
  for i=1, world.sizex, 1 do
    for j=1, world.sizey, 1 do
      world.map[i][j].box = love.math.random(0,4)
      if world.map[i][j].box > 1 then
        world.map[i][j].box = 0
      end
    end
  end
  world.map[1][1].box = 0
  world.map[1][2].box = 0
  world.map[2][1].box = 0
  world.map[2][2].box = 0
end

function scenario.checkWin(world, player)
  if player.sqmx == world.sizex and player.sqmy == world.sizey then
    world.diff = world.diff+1
    player.sqmx=1
    player.sqmy=1
    player.targetx=1
    player.targety=1
    scenario.remake(world)
  end
end

return scenario