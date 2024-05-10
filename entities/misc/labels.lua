local helpers = require"entities/helpers"
local ch = require"helpers/color_helpers"

local module = {}


-- Create a specific label
function module.create_label(x, y, text, colors, scale, angle)
  -- local alpha = 255

  local label = new_entity(x, y)
  entity_set_mesh_scale(label, scale)
  entity_add_mesh_angle(label, angle, 0fx, 0fx, 1fx)

  local time = 0
  function label_update_callback()
    time = time + 1

    local color = helpers.get_color_state(time)
    if color ~= nil then
      local color = colors[color]
      local text = ch.color_to_string(color) .. text
      entity_set_string(label, text)
    end
  end

  entity_set_update_callback(label, label_update_callback)

  return label
end


function module.create_bold_label(x, y, text, colors, scale, angle, width)

  for i=1, width do
    local label = module.create_label(x+i, y+i, text, colors, 3fx/2fx, angle)
  end

end


-- Create all the decorative labels around the level's border
function module.create_decorations(lw, lh)
  local colors = {0x00ff00ff, 0x0000ffff,
    0xff9100ff, 0x808080ff}

  local label1_text = "Fast Forward ⏩"
  local label2_text = "@artiekra"

  module.create_bold_label(-40fx, 200fx, label1_text, colors, 3fx/2fx, FX_TAU/4fx, 3)
  module.create_bold_label(lw+40fx, lh-120fx, label2_text, colors, 3fx/2fx, 3fx*FX_TAU/4fx, 3)

end


return module
