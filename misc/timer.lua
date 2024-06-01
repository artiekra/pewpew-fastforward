-- [TODO: merge the code with level border (static) labels]

local helpers = require"entities/helpers"
local ch = require"helpers/color_helpers"

local module = {}

module.CURRENT_COLOR = 0


-- Convert ticks to formatted text (time string)
function time_to_text(time)
  local minutes = time // 1800
  local seconds = (time//30) % 60
  local ticks = time%30

  -- local text = string.format("%02d:%02d", minutes, seconds)
  local text = string.format("%02d:%02d.%02d", minutes, seconds, ticks)

  return text
end


-- Create a specific label
function module.create_label(x, y, text, colors, scale, angle)
  -- local alpha = 255

  local label = new_entity(x, y)
  entity_set_mesh_scale(label, scale)
  entity_add_mesh_angle(label, angle, 0fx, 0fx, 1fx)

  return label
end


function module.create_bold_label(x, y, text, colors, scale, angle, width)
  labels = {}

  for i=1, width do
    local label = module.create_label(x+i, y+i, text, colors, scale, angle)
    table.insert(labels, label)
  end

  return labels
end


-- Create the timer
-- [TODO: use coordinates based on small border box ones here]
function module.init(lw, lh)
  local labels = module.create_bold_label(lw-165fx, lh+52.2048fx, "timer", colors,
    1fx, 0fx, 2)

  return labels
end


-- Update the timer
function module.update(labels, time)
  local colors = {0x00ff00ff, 0x0000ffff,
    0xff9100ff, 0x808080ff}

  text = time_to_text(18000-time)

  local color = helpers.get_color_state(time)
  if color ~= nil then
    module.CURRENT_COLOR = colors[color]
  end

  for i, label in ipairs(labels) do
    text = ch.color_to_string(module.CURRENT_COLOR) .. text
    entity_set_string(label, text)
  end

end


return module
