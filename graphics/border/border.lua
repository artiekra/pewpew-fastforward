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


function make_mesh(color1, color2)
  local mesh = gh.new_mesh()
  local lw = to_int(LEVEL_WIDTH)
  local lh = to_int(LEVEL_HEIGHT)
  local bevel = to_int(BEVEL_SIZE)

  -- draw main border, one thick line
  local init_z = 10
  for i=1, BORDER_WIDTH do
    local d = (i - 1) * 2
    draw_border_outline(mesh, lw-d, lh-d, bevel, color1, color2, 10)
  end

  -- draw borders lower
  for z=init_z, -100, -25 do
    local color1 = ch.make_color_with_alpha(color1, 2*z+225)
    local color2 = ch.make_color_with_alpha(color2, 2*z+225)
    draw_border_outline(mesh, lw, lh, bevel, color1, color2, z)
  end

  return mesh
end


meshes = {
  make_mesh(COLOR_MAIN1_1, COLOR_MAIN1_2),
  make_mesh(COLOR_MAIN2_1, COLOR_MAIN2_2)
}
