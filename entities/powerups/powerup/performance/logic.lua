local template = require"entities/powerups/template"
local performance = require"misc/performance"
require"entities/powerups/config"

local module = {}


function performance_player_collision(entity_id, player_id, ship_id, multiplier)
  local duration = 135

  performance.upgrade(multiplier, duration)
end


-- Spawn entity, add update callback
function module.spawn(ship_id, x, y, multiplier)
  local colors = {
    {0x008015ff, 0x450044ff, 0x940c00ff, 0x808080ff0},
    {0x008015ff, 0x450044ff, 0x940c00ff, 0x808080ff0},
    {0x008015ff, 0x450044ff, 0x940c00ff, 0x808080ff0},
  }

  local text = "x" .. multiplier .. " performance"
  local outer_box, inner_box = template.spawn(ship_id, x, y, "entities/powerups/powerup/performance/icon",
    text, colors, performance_player_collision)

  return outer_box, inner_box
end


return module
