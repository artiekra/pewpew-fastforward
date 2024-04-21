module = {}


-- Create a specific label
function module.create_label(x, y, text, scale, angle)
  -- local alpha = 255

  local label = new_entity(x, y)
  entity_set_mesh_scale(label, scale)
  entity_add_mesh_angle(label, angle, 0fx, 0fx, 1fx)

  -- local color = ch.make_color_with_alpha(color, alpha)
  -- local color_s = ch.color_to_string(color)
  entity_set_string(label, text)

  return label
end


function module.create_bold_label(x, y, text, scale, angle, width)

  for i=1, width do
    local label = module.create_label(x+i, y+i, text, 3fx/2fx, angle)
  end

end


-- Create all the decorative labels around the level's border
function module.create_decorations(lw, lh)

  local label1_text = "#00e31affFast Forward #02ba17ff⏩" 
  local label2_text = "#00e31aff@artiekra"

  module.create_bold_label(-40fx, 200fx, label1_text, 3fx/2fx, FX_TAU/4fx, 3)
  module.create_bold_label(lw+40fx, lh-120fx, label2_text, 3fx/2fx, 3fx*FX_TAU/4fx, 3)

end


return module
