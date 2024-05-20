local fm = require"helpers/floating_message"
local template = require"entities/powerups/template"
require"entities/powerups/config"

local module = {}


function performance_player_collision(entity_id, player_id, ship_id)
  set_shield(get_shield() + 1)
end


-- Spawn entity, add update callback
function module.spawn(ship_id, x, y)
  local colors = {
    {0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff},
    {0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff},
    {0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff},
  }

  function inner_box_player_collision(entity_id, player_id, ship_id)
    performance_player_collision(entity_id, player_id, ship_id)
    entity_destroy(entity_id)
  end

  local outer_box, inner_box = template.spawn(ship_id, x, y, "entities/powerups/powerup/performance/icon",
    "x3 performance", colors, shield_player_collision)
  entity_set_player_collision(inner_box, inner_box_player_collision)

  return outer_box, inner_box
end


return module
