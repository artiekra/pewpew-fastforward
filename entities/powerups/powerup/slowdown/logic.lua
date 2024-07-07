local template = require"entities/powerups/template"
local events = require"events"

require"entities/powerups/config"
require"globals/general"
require"helpers/easing"

local module = {}


  -- [TODO: potentially can rollback another powerup]
function slowdown_player_collision(entity_id, player_id, ship_id)

  TIME_FACTOR = 4

  -- slowly revert the changes
  local mf = 1
  local nf = 4
  local st = 80
  local et = 135
  for i=st, et do
    -- [NOTE: https://jpcdn.it/img/a5f4af01882a096a2decffce3c20cf26.png]
    events.register_event(i, function()
      local new_factor = ((i-st)*(mf-nf))/(et-st)+nf
      TIME_FACTOR = ease_in_out_cubic(new_factor, nf, mf)
    end)
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
