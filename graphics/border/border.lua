require"/dynamic/ppol/.lua"

gh = require"helpers/graphics_helpers"
ch = require"helpers/color_helpers"

require"globals"
require"graphics/border/config"


---- Draws simple shape to outline the border
-- bevel is the size of the bevel
-- two colors create a gradient
function draw_border_outline(mesh, width, height, bevel, color1, color2, z)
  local hw = width / 2
  local hh = height / 2
  local b = bevel
  gh.add_line_to_mesh(
    mesh,
      {{-hw, -hh, z}, {hw-b, -hh, z}, {hw, -hh+b, z}, {hw, hh, z},
       {-hw+b, hh, z}, {-hw, hh-b, z}},
    {color1, color1, color1, color2, color2, color2}, 1
  )

end


function make_mesh()
  mesh = gh.new_mesh()
  lw = to_int(LEVEL_WIDTH)
  lh = to_int(LEVEL_HEIGHT)

  -- draw main border, one thick line
  local init_z = 10
  for i=1, BORDER_WIDTH do
    local d = (i - 1) * 2
    draw_border_outline(mesh, lw-d, lh-d, BEVEL_SIZE, COLOR_MAIN1, COLOR_MAIN2, 10)
  end

  -- draw borders lower
  for z=init_z, -100, -25 do
    draw_border_outline(mesh, lw, lh, BEVEL_SIZE, COLOR_MAIN1, COLOR_MAIN2, z)
  end

  return mesh
end


meshes = {make_mesh()}
