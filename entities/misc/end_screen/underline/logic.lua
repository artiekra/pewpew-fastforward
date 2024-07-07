local time = require"misc/time"

require"helpers/colors"

underline_module = {}


-- Function to call every tick on entity
-- [TODO: make this work..]
local function update_callback(id)
  local hue = ((i+time.TIME//3) % 45) * 8
  local rgb = ch.make_color(hsv_to_rgb(hue, 100, 50))
end


-- Spawn entity (label underline)
function underline_module.spawn(x, y)
  local ids = {}

  for i=0, 8 do
    local underline = new_entity(x, y-i)
    entity_set_mesh(underline, "entities/misc/end_screen/underline/mesh")
    -- entity_set_update_callback(underline, update_callback)

    table.insert(ids, underline)
  end

  return ids
end


return underline_module
