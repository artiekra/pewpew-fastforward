require"globals/general"

local module = {}


-- Dynamically set angle of weapon "TRIPLE"
-- https://jpcdn.it/img/91227887dd6cfc276304a68cd908f741.png
function module.update(time, x, y)
  log.debug("shoot", "Shooting, time", time, " and x y", x, y)

  local max_spread = 1fx/3fx

  if inputs.sd > 0fx then
    local a = max_spread * inputs.sd
    if time % (30//WEAPON_HZ*2) == 0 then
      log.trace("shoot", "Spawning player bullets..")
      new_player_bullet(x, y, inputs.sa-a)
      new_player_bullet(x, y, inputs.sa)
      new_player_bullet(x, y, inputs.sa+a)
      play_sound("sounds/shoot")

    elseif time % (30//WEAPON_HZ) == 0 then
      log.trace("shoot", "Spawning player bullets..")
      new_player_bullet(x, y, inputs.sa-(a/2))
      new_player_bullet(x, y, inputs.sa+(a/2))
      play_sound("sounds/shoot")
    end
  end
end


return module
