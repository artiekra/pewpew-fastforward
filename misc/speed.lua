require"globals/general"

local module = {}

module.SPEED = 1


-- If speed < limit, update it (increment)
function module.update_ship_speed(speed)
  local increment_val = 0.01
  local limit = 2

  module.SPEED = module.SPEED + increment_val
  if module.SPEED > limit then
    module.SPEED = limit
  end

  return speed
end


-- Apply speed, should be called each tick
-- [TODO: consider easing?]
function module.apply_speed()
  if FREEZE_PLAYER then
    set_player_ship_speed(1, 0fx)
  else
    set_player_ship_speed(1, to_fx((module.SPEED*100)//10))
  end
end


return module
