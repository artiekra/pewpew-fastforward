local fm = require"helpers/floating_message"
local template = require"entities/powerups/template"

local module = {}


function shield_player_collision(entity_id, player_id, ship_id)
  set_shield(get_shield() + 1)
end


-- Spawn entity, add update callback
function module.spawn(ship_id, x, y)

  local shield = template.spawn(ship_id, x, y, "entities/powerups/shield/mesh",
    "entities/powerups/shield/icon", "+1 shield", 0x007a50ff, shield_player_collision)

  return shield
end


return module
