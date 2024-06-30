local helpers = require"entities/helpers/general"

local module = {}

local colors = {0x00ff00ff, 0x0000ffff,
  0xff9100ff, 0x808080ff}


-- Spawn entity (border), add update callback
function module.spawn(x, y)
  log.debug("Creating level border at", x, y)

  local border = new_entity(x, y)
  entity_set_mesh(border, "entities/graphics/border/mesh")

  local time = 0
  function border_update_callback()
    time = time + 1

    helpers.set_entity_color(border, colors)
  end

  entity_set_update_callback(border, border_update_callback)

  return border
end


return module
