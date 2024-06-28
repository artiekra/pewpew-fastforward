local helpers = require"entities/helpers/labels"

local module = {}


-- Create all the decorative labels around the level's border
function module.create_decorations(lw, lh)
  local colors = {0x00ff00ff, 0x0000ffff,
    0xff9100ff, 0x808080ff}

  local label1_text = "Fast Forward ⏩"
  local label2_text = "@artiekra"

  helpers.create_bold_label(-40fx, 200fx, label1_text, colors, 3fx/2fx, FX_TAU/4fx, 0fx, 3)
  helpers.create_bold_label(lw+40fx, lh-120fx, label2_text, colors, 3fx/2fx, 3fx*FX_TAU/4fx, 0fx, 3)

end


return module
