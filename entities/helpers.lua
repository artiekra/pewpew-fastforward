require"globals"

local module = {}


-- Useful generalisation for set_entity_color(),
-- based on LEVEL_MODE
function module.get_color_state(time)
  local flicker_speed = 0.2

  -- colors isn't changing right now
  if LEVEL_MODE % 2 == 0 then
    local color = (LEVEL_MODE+2) / 2
    return color
  end

  -- color should flicker
  -- [TODO: combine with the previous if, with else?]
  if LEVEL_MODE % 2 == 1 then
    n = random(0, 1)
    if time % (1//flicker_speed) == 0 then  -- make flickering a bit slower
      if n == 0 then
        local color = (LEVEL_MODE+3) / 2
        return color
      else
        local color = (LEVEL_MODE+1) / 2
        return color
      end
    end
  end

  return nil
end


-- Get the right color for the mesh, based on LEVEL_MODE,
-- and also set it right away
function module.set_entity_color(time, entity, colors)

  local color_state = module.get_color_state(time)
  if color_state ~= nil then
    local color = colors[color_state]
    entity_set_mesh_color(entity, color)
    return color
  end
 
  return nil
end


-- Get random coordinates, that are not too close to the player
-- Specify an offset to not spawn to close to the border
function module.random_coordinates(ship, player_zone, offset)

  while true do
    ::continue::

    -- Get random coordinates (not near border)
    x = fx_random(offset, LEVEL_WIDTH-offset)
    y = fx_random(offset, LEVEL_HEIGHT-offset)
    
    player_x, player_y = entity_get_pos(ship)

    -- Dissallow coordinates near the player
    if fx_abs(y - player_y) < player_zone and
       fx_abs(x - player_x) < player_zone then
      goto continue
    end

    -- Dont spawn outside bevels
    -- [TODO: allow spawning close to them]
    if (x < BEVEL_SIZE and y > LEVEL_HEIGHT - BEVEL_SIZE) or
       (x > LEVEL_WIDTH - BEVEL_SIZE and y < BEVEL_SIZE) then
      goto continue
    end

    return x, y
  end

end


return module
