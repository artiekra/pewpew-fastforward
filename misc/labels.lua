local module = {}


-- Create a specific label
function module.create_label(x, y, text, scale, angle)
  -- local alpha = 255

  local label = new_entity(x, y)
  entity_set_mesh_scale(label, scale)
  entity_add_mesh_angle(label, angle, 0fx, 0fx, 1fx)

  function label_update_callback()
    local flicker_speed = 0.2

    if LEVEL_MODE == 0 then
      entity_set_string(label, text[1])
    elseif LEVEL_MODE == 1 then
      n = random(0, 1)
      if time % (1//flicker_speed) == 0 then  -- make flickering a bit slower
        if n == 0 then
          entity_set_string(label, text[1])
        else
          entity_set_string(label, text[2])
        end
      end
    elseif LEVEL_MODE == 2 then
      entity_set_string(label, text[2])
    end

  end

  entity_set_update_callback(label, label_update_callback)

  return label
end


function module.create_bold_label(x, y, text, scale, angle, width)

  for i=1, width do
    local label = module.create_label(x+i, y+i, text, 3fx/2fx, angle)
  end

end


-- Create all the decorative labels around the level's border
function module.create_decorations(lw, lh)

  -- [TODO: use color helpers, specify text only once]
  local label1_text = {
    "#00e31affFast Forward ⏩",
    "#2c15c2ffFast Forward ⏩"
  }
  local label2_text = {
    "#00e31aff@artiekra",
    "#2c15c2ff@artiekra"
  }

  module.create_bold_label(-40fx, 200fx, label1_text, 3fx/2fx, FX_TAU/4fx, 3)
  module.create_bold_label(lw+40fx, lh-120fx, label2_text, 3fx/2fx, 3fx*FX_TAU/4fx, 3)

end


return module
