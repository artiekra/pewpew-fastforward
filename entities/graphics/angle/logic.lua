local helpers = require"entities/helpers"

local module = {}

local colors = {0x00ff00ff, 0x0000ffff,
  0xff9100ff, 0x808080ff}


-- Spawn entity (border decoration), add update callback
-- [TODO: add music visualisation]
function module.spawn(x, y, pos_angle)
  local angle = new_entity(x, y)
  entity_set_mesh(angle, "entities/graphics/angle/mesh")
  entity_add_mesh_angle(angle, pos_angle, 0fx, 0fx, 1fx)

  local time = 0
  function angle_update_callback()
    time = time + 1

    local color = helpers.get_mesh_color(time, colors)
    if color ~= nil then
      entity_set_mesh_color(angle, color)
    end
  end

  entity_set_update_callback(angle, angle_update_callback)

  return angle
end


return module
