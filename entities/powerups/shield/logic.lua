local fm = require"helpers/floating_message"
local template = require"entities/powerups/template"
require"entities/powerups/config"

local module = {}


function shield_player_collision(entity_id, player_id, ship_id)
  set_shield(get_shield() + 1)
end


-- Spawn entity, add update callback
function module.spawn(ship_id, x, y)
  local color_icon1 = 0x007a50ff
  local color_outer1 = 0x007a50ff
  local color_icon2 = 0x0000ffff
  local color_outer2 = 0x0000ffff
  local color_text1 = 0x007a50ff
  local color_text2 = 0x0000ffff

  local colors = {
    {color_outer1, color_outer2},
    {color_icon1, color_icon2},
    {color_text1, color_text2}
  }

  local shield = template.spawn(ship_id, x, y, "entities/powerups/shield/icon",
    "+1 shield", colors, shield_player_collision)

  return shield
end


return module
