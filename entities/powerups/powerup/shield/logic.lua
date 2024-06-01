local template = require"entities/powerups/template"
require"entities/powerups/config"

local module = {}


function shield_player_collision(entity_id, player_id, ship_id)
  set_shield(get_shield() + 1)
end


-- Spawn entity, add update callback
function module.spawn(ship_id, x, y)
  local colors = {
    {0x007a50ff, 0x0000ffff, 0xe07400ff, 0x808080ff},
    {0x007a50ff, 0x0000ffff, 0xe07400ff, 0x808080ff},
    {0x007a50ff, 0x0000ffff, 0xe07400ff, 0x808080ff}
  }

    local outer_box, inner_box = template.spawn(ship_id, x, y, "entities/powerups/powerup/shield/icon",
    "+1 shield", colors, shield_player_collision)

  return outer_box, inner_box
end


return module
