local template = require"entities/powerups/template"
local time_factor = require"misc/time/factor"
local events = require"events"

require"entities/powerups/config"
require"globals/general"
require"helpers/easing"

local module = {}


function slowdown_player_collision(entity_id, player_id, ship_id)
  time_factor.change_time_factor(0.25, 20)
  events.register_event(320, function()
    time_factor.change_time_factor(1, 55)
  end)
end


-- Spawn entity, add update callback
function module.spawn(ship_id, x, y)
  local colors = {
    {0x007a50ff, 0x0000ffff, 0xe07400ff, 0x808080ff},
    {0x007a50ff, 0x0000ffff, 0xe07400ff, 0x808080ff},
    {0x007a50ff, 0x0000ffff, 0xe07400ff, 0x808080ff}
  }

  local outer_box, inner_box = template.spawn(ship_id, x, y, "entities/powerups/powerup/slowdown/icon",
    "time slowed down!", colors, slowdown_player_collision)

  return outer_box, inner_box
end


return module
