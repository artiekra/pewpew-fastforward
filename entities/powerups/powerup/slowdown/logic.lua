local template = require"entities/powerups/template"
local events = require"events"

require"entities/powerups/config"
require"globals/general"

local module = {}


function slowdown_player_collision(entity_id, player_id, ship_id)

  -- [TODO: potentially can rollback another powerup]
  function rollback_effect(new_factor)
    TIME_FACTOR = (new_factor or 1)
  end

  TIME_FACTOR = 3
  for i=60, 100 do
    events.register_event(i, rollback_effect, 3.5-(i/40))
  end

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
