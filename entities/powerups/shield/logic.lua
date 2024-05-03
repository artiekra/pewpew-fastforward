local fm = require"helpers/floating_message"
local template = require"entities/powerups/template"
require"entities/powerups/config"

local module = {}


function shield_player_collision(entity_id, player_id, ship_id)
  set_shield(get_shield() + 1)
end


-- Spawn entity, add update callback
function module.spawn(ship_id, x, y)

  local shield = template.spawn(ship_id, x, y, "entities/powerups/shield/mesh",
    "entities/powerups/shield/icon", "+1 shield", COLOR_SHIELD_POWERUP, shield_player_collision)

  return shield
end


return module
