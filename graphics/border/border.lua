require"/dynamic/ppol/.lua"

gh = require"helpers/graphics_helpers"
ch = require"helpers/color_helpers"

require"globals"
require"graphics/border/config"

lh = to_int(LEVEL_HEIGHT)
lw = to_int(LEVEL_WIDTH)


function make_mesh()
  mesh = gh.new_mesh()

  -- draw border outline
  b = BEVEL_SIZE
  gh.add_line_to_mesh(mesh, {{0, 0}, {lw-b, 0}, {lw, b}, {lw, lh}, {b, lh}, {0, lh-b}}, {COLOR_MAIN}, 1)

  return mesh
end


meshes = {make_mesh()}
