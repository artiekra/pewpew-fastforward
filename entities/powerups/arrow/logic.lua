local performance = require"misc/performance"
local helpers = require"entities/helpers/general"

local module = {}


-- Add arrow near the owner, which points to the target
function module.add_arrow(owner, target, colors)
  local distance = 25fx

  local arrow = new_entity(entity_get_pos(owner))
  entity_start_spawning(arrow, 2)
  entity_set_mesh(arrow, "entities/powerups/arrow/mesh")

  local time = 0
  function arrow_update_callback()
    time = time + 1

    -- destroy the arrow if owner/target dont exist anymore
    if not entity_get_is_alive(target) or
       not entity_get_is_alive(owner) then
      entity_set_mesh_color(arrow, 0x00000000)
      entity_destroy(arrow)
      return
    end

    local ox, oy = entity_get_pos(owner)
    local tx, ty = entity_get_pos(target)

    -- point to the target
    -- [NOTE: arrow is in between owner and target, atan2 is the same,
    --  both for when you base on on owner, and on arrow itself?]
    local angle = fx_atan2(ty-oy, tx-ox)
    entity_set_mesh_angle(arrow, angle, 0fx, 0fx, 1fx)

    -- follow the owner
    local dy, dx = fx_sincos(angle)
    entity_set_pos(arrow, ox+dx*distance, oy+dy*distance)

    -- change colors according to level mode
    helpers.set_entity_color(time, arrow, colors)
  end

  entity_set_update_callback(arrow, arrow_update_callback)

  return arrow
end


return module
