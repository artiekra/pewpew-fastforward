local template = require"entities/powerups/template"
local performance = require"misc/score/performance"
require"entities/powerups/config"

local module = {}


function points_player_collision(entity_id, player_id, ship_id)
  -- [NOTE: consider not accounting from performance here?]
  performance.increase_player_score(1000)
end


-- Spawn entity, add update callback
function module.spawn(ship_id, x, y)
  local colors = {
    {0x21d900ff, 0x4e0582ff, 0xe04000ff, 0x808080ff},
    {0x21d900ff, 0x4e0582ff, 0xe04000ff, 0x808080ff},
    {0x21d900ff, 0x4e0582ff, 0xe04000ff, 0x808080ff}
  }

  local outer_box, inner_box = template.spawn(ship_id, x, y, "entities/powerups/powerup/score/icon",
    "+1K points", colors, points_player_collision)

  return outer_box, inner_box
end


return module
