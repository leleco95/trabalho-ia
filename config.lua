local config = {}

function config.load()
  
  local global = {
    title = "World Shifter",
    sizex = 800,
    sizey = 608,
    frame_timer = 0.07,
    walk_delay = 0.1,
    fire_timer = 0.3,
  }
  
  return global
end

return config