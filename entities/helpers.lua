require"globals"

local module = {}


function module.get_mesh_color(time, color1, color2)
  local flicker_speed = 0.2

  if LEVEL_MODE == 0 then
    return color1
  elseif LEVEL_MODE == 1 then
    n = random(0, 1)
    if time % (1//flicker_speed) == 0 then  -- make flickering a bit slower
      if n == 0 then
        return color1
      else
        return color2
      end
    end
  elseif LEVEL_MODE == 2 then
    return color2
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
