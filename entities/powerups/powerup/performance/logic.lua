local fm = require"helpers/floating_message"
local template = require"entities/powerups/template"
require"entities/powerups/config"

local module = {}


function performance_player_collision(entity_id, player_id, ship_id, multiplyer)
  set_shield(get_shield() + multiplyer)
end


-- Spawn entity, add update callback
function module.spawn(ship_id, x, y, multiplyer)
  local colors = {
    {0x008015ff, 0x450044ff, 0x940c00ff, 0x808080ff0},
    {0x008015ff, 0x450044ff, 0x940c00ff, 0x808080ff0},
    {0x008015ff, 0x450044ff, 0x940c00ff, 0x808080ff0},
  }

  function inner_box_player_collision(entity_id, player_id, ship_id)
    performance_player_collision(entity_id, player_id, ship_id, multiplyer)
    entity_destroy(entity_id)
  end

  local text = "x" .. multiplyer .. " performance"
  local outer_box, inner_box = template.spawn(ship_id, x, y, "entities/powerups/powerup/performance/icon",
    text, colors, shield_player_collision)
  entity_set_player_collision(inner_box, inner_box_player_collision)

  return outer_box, inner_box
end


return module
