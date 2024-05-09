require"graphics/border/config"

local helpers = require"entities/helpers"

local module = {}


-- Spawn entity (border decoration), add update callback
-- [TODO: add music visualisation]
function module.spawn(x, y, pos_angle)
  local angle = new_entity(x, y)
  entity_set_mesh(angle, "graphics/angle/mesh")
  entity_add_mesh_angle(angle, pos_angle, 0fx, 0fx, 1fx)

  local time = 0
  function angle_update_callback()
    time = time + 1

    color = helpers.get_mesh_color(time, COLOR_MAIN1_1, COLOR_MAIN2_1)
    if color ~= nil then
      entity_set_mesh_color(angle, color)
    end
  end

  entity_set_update_callback(angle, angle_update_callback)

  return angle
end


return module
