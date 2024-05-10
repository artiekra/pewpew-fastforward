local helpers = require"entities/helpers"

local module = {}

local colors = {0x00ff00ff, 0x0000ffff,
  0xff0000ff, 0x808080ff}


-- Spawn entity (border decoration), add update callback
-- [TODO: add music visualisation]
function module.spawn(x, y)
  local border = new_entity(x, y)
  entity_set_mesh(border, "entities/graphics/border/mesh")

  local time = 0
  function border_update_callback()
    time = time + 1

    local color = helpers.get_mesh_color(time, colors)
    if color ~= nil then
      entity_set_mesh_color(border, color)
    end
  end

  entity_set_update_callback(border, border_update_callback)

  return border
end


return module
