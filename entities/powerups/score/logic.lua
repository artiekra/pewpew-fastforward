local fm = require"helpers/floating_message"
local template = require"entities/powerups/template"
require"entities/powerups/config"

local module = {}


function points_player_collision(entity_id, player_id, ship_id)
  increase_score(10)
end


-- Spawn entity, add update callback
function module.spawn(ship_id, x, y)

  local shield = template.spawn(ship_id, x, y, "entities/powerups/score/mesh",
    "entities/powerups/score/icon", "+10 points", COLOR_SCORE_POWERUP, points_player_collision)

  return shield
end


return module
