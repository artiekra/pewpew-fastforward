local fm = require"helpers/floating_message"
local template = require"entities/powerups/template"
local performance = require"misc/performance"
require"entities/powerups/config"

local module = {}


function points_player_collision(entity_id, player_id, ship_id)
  -- [NOTE: consider not accounting from performance here?]
  performance.increase_player_score(10)
end


-- Spawn entity, add update callback
function module.spawn(ship_id, x, y)
  local color_icon1 = 0x21d900ff
  local color_outer1 = 0x21d900ff
  local color_icon2 = 0x4e0582ff
  local color_outer2 = 0x4e0582ff
  local color_text1 = 0x21d900ff
  local color_text2 = 0x4e0582ff

  local colors = {
    {color_outer1, color_outer2},
    {color_icon1, color_icon2},
    {color_text1, color_text2}
  }

  local shield = template.spawn(ship_id, x, y, "entities/powerups/powerup/score/icon",
    "+10 points", colors, points_player_collision)

  return shield
end


return module
