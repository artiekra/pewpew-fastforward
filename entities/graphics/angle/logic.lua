local helpers = require"entities/helpers"

local module = {}

local colors = {0x00ff00ff, 0x0000ffff,
  0xff9100ff, 0x808080ff}


-- Spawn entity (border decoration), add update callback
function module.spawn(x, y, pos_angle)
  local angle = new_entity(x, y)
  entity_set_mesh(angle, "entities/graphics/angle/mesh")
  entity_add_mesh_angle(angle, pos_angle, 0fx, 0fx, 1fx)

  local time = 0
  function angle_update_callback()
    time = time + 1

    helpers.set_entity_color(time, angle, colors)
  end

  entity_set_update_callback(angle, angle_update_callback)
  entity_set_music_sync(angle, {scale_x_start = 1fx, scale_x_end = 6fx/5fx,
    scale_y_start = 1fx, scale_y_end = 6fx/5fx})

  return angle
end


return module
