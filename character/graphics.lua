local character = {}

function character.load(player)
  local count = 1  
  for j = 0, 3, 1 do
    for i = 0, 4, 1 do
      player.charQuads[count]=love.graphics.newQuad(i * 32, j * 32, 32, 32, player.charImage:getWidth(),player.charImage:getHeight())
      count = count + 1
    end
  end
end

function character.changeFrame(player, timer)
  if player.frame_timer > timer then
    player.frame = player.frame + 1
    player.frame_timer = 0
  end
  if player.frame > player.dir*5+5 or player.frame < player.dir*5+1 then
    player.frame = player.dir*5+1
  end
end

return character