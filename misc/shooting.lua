require"globals"

local module = {}


-- Dynamically set angle of weapon "TRIPLE"
-- https://jpcdn.it/img/91227887dd6cfc276304a68cd908f741.png
function module.update(time, x, y)
  local max_spread = 1fx/3fx

  local move_angle, move_distance, shoot_angle, shoot_distance = get_inputs()

  if shoot_distance > 0fx then
    local a = max_spread * shoot_distance
    if time % (30//WEAPON_HZ*2) == 0 then
      new_player_bullet(x, y, shoot_angle-a)
      new_player_bullet(x, y, shoot_angle)
      new_player_bullet(x, y, shoot_angle+a)

    elseif time % (30//WEAPON_HZ) == 0 then
      new_player_bullet(x, y, shoot_angle-(a/2))
      new_player_bullet(x, y, shoot_angle+(a/2))
    end

  end
end


return module
