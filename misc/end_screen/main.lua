-- [TODO: combine some of the functions with the ones from entities/misc/labels]

require"globals"
require"misc/end_screen/data"

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
    local label = module.create_label(x+i, y+i, text, colors, scale, angle)
  end

end


-- Show end screen text
function module.show_text()

  -- [TODO: maybe change the responsibility for this to another module?]
  -- [TODO: make this smooth]
  camera.offset_z = -750fx

  local colors = {0x00ff00ff, 0x0000ffff,
    0xff9100ff, 0x808080ff}

  local main_label_text = MAIN_LABEL_VARIATIONS[random(1, 3)]
  module.create_bold_label(LEVEL_WIDTH/2fx, LEVEL_HEIGHT/2fx, main_label_text, colors, 3fx, 0fx, 5)

end


return module
