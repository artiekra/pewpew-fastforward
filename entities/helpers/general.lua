local level_time = require"misc/time"

require"globals/general"

local module = {}


-- Useful generalisation for set_entity_color(),
-- based on LEVEL_MODE
function module.get_color_state()
  local time = level_time.get_time()
  log.extra("hlpr", "Getting color state for time", time)

  local flicker_speed = 0.2

  -- completely black, everything
  -- [TODO: maybe leave "ghost" enemies? make them grey.. they cant hurt]
  if LEVEL_MODE == -2 then
    return -1  -- black on end screen
  end

  if LEVEL_MODE == -1 then
    n = random(0, 5)  -- increased chances of NOT changing to end screen color
    if time % (1//flicker_speed) == 0 then  -- make flickering a bit slower
      if n == 0 then
        return -1
      end
      return nil
    end
  end

  -- colors isn't changing right now
  if LEVEL_MODE % 2 == 0 then
    local color = (LEVEL_MODE+2) / 2
    return color
  -- color should flicker
  -- if LEVEL_MODE % 2 == 1 then
  else
    n = random(0, 1)
    if time % (1//flicker_speed) == 0 then  -- make flickering a bit slower
      if n == 0 then
        local color = (LEVEL_MODE+3) / 2
        return color
      end
      local color = (LEVEL_MODE+1) / 2
      return color
    end
  end

  log.extra("hlpr", "get_color_state() - Returning nil..")
  return nil
end


-- Get the right color for the mesh, based on LEVEL_MODE,
-- and also set it right away
function module.set_entity_color(entity, colors)
  log.extra("hlpr", "Setting entity color for", entity)

  local color_state = module.get_color_state()
  if color_state then

    local color
    if color_state >= 0 then
      color = colors[color_state]
    else
      color = END_SCREEN_ENTITY_COLOR
    end

    entity_set_mesh_color(entity, color)
    return color

  end
 
  return nil
end


-- Get random coordinates, that are not too close to the player
-- Specify an offset to not spawn to close to the border
function module.random_coordinates(ship, player_zone, offset)
  
  local x, y
  local px, py = entity_get_pos(ship)
  
  repeat
    x = fx_random(offset, LEVEL_WIDTH - offset)
    y = fx_random(offset, LEVEL_HEIGHT - offset)
  until fx_abs(x - px) > player_zone and fx_abs(y - py) > player_zone and
    x > BEVEL_SIZE and x < LEVEL_WIDTH - BEVEL_SIZE and y > BEVEL_SIZE and
    y < LEVEL_HEIGHT - BEVEL_SIZE
  
  return x, y

end


return module
