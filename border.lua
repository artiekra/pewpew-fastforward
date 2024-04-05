require"/dynamic/ppol/.lua"
gh = require"helpers/graphics_helpers"
ch = require"helpers/color_helpers"
require"globals"

lh = to_int(LEVEL_HEIGHT)
lw = to_int(LEVEL_WIDTH)

-- meshes = {
--
--   {
--     vertexes = {{0, 0}, {lw, 0}, {lw, lh}, {0, lh}},
--     segments = {{0, 1, 2, 3, 0}},
--     colors = {0xffffffff}
--   },
--
-- }

meshes = {gh.new_mesh()}
gh.add_line_to_mesh(meshes[1], {{0, 0}, {lw, 0}, {lw, lh}, {0, lh}}, {0xffffffff}, 1)
