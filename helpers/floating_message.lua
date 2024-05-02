local ch = require"helpers/color_helpers"

local floating_message = {}

function floating_message.new(x, y, text, scale, color, d_alpha)
  local id = new_entity(x, y, false)
  local z = 0fx
  local alpha = 255
  entity_set_mesh_scale(id, scale)


  entity_set_update_callback(id, function()
    z = z + 20fx
    local color = ch.make_color_with_alpha(color, alpha)
    local color_s = ch.color_to_string(color)
    entity_set_string(id, color_s .. text)

    entity_set_mesh_xyz(id, 0fx, 0fx, z)

    alpha = alpha - d_alpha
    if alpha <= 0 then
      entity_destroy(id)
    end
  end)
  return id
end

return floating_message
