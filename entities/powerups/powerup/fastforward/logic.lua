local template = require"entities/powerups/template"
local events = require"events"

require"entities/powerups/config"
require"globals/general"

local module = {}


function fastforward_player_collision(entity_id, player_id, ship_id)
  set_shield(get_shield() + 1)
end


-- Spawn entity, add update callback
function module.spawn(ship_id, x, y)
  -- local colors = {
  --   {0x007a50ff, 0x0000ffff, 0xe07400ff, 0x808080ff},
  --   {0x007a50ff, 0x0000ffff, 0xe07400ff, 0x808080ff},
  --   {0x007a50ff, 0x0000ffff, 0xe07400ff, 0x808080ff}
  -- }

  local outer_box, inner_box = template.spawn(ship_id, x, y, "entities/powerups/powerup/fastforward/icon",
    "fast forward!", nil, fastforward_player_collision)

  return outer_box, inner_box
end


return module
