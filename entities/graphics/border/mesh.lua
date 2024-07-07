require"/dynamic/libs/ppol/.lua"

local gh = require"helpers/graphics_helpers"

require"globals/general"


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
    {color1, color1, color1, color2, color2, color2}, true
  )

  -- small border boxes
  local sd = 25
  local sh = 55
  local sw = 325

  local so = hw - sw
  -- [TODO: fix top layer not being bold when 1st coord is so-sh (no /2)]
  gh.add_line_to_mesh(mesh, {{so-sh/2, hh+sd, z}, {so, hh+sd+sh, z},
                             {hw, hh+sd+sh, z}, {hw, hh+sd, z}},
    {color1, color1, color2, color2}, true)

  -- border bottom line decoration
  local ld = 25
  local lw = 325
  local lo = lw-hw
  gh.add_line_to_mesh(mesh, {{-hw, -hh-ld, z}, {lo, -hh-ld, z}},
    {color1, color2}, false)

end


function make_mesh(color1, color2)
  local mesh = gh.new_mesh()
  local lw = to_int(LEVEL_WIDTH)
  local lh = to_int(LEVEL_HEIGHT)
  local bevel = to_int(BEVEL_SIZE)

  -- draw main border, one thick line
  local init_z = 10
  for i=1, 5 do
    local d = (i - 1) * 2
    draw_border_outline(mesh, lw-d, lh-d, bevel, color1, color2, 10)
  end

  -- draw borders lower
  for z=init_z, -100, -25 do
    local color1 = change_alpha(color1, 2*z+225)
    local color2 = change_alpha(color2, 2*z+225)
    draw_border_outline(mesh, lw, lh, bevel, color1, color2, z)
  end

  return mesh
end


meshes = {
  make_mesh(0xffffffff, 0xffffffff)
}
