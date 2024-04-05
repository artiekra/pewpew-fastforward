require"/dynamic/ppol/.lua"
require"helpers/graphics_helpers"
require"helpers/color_helpers"

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

add_line_to_mesh(meshes, {{0, 0}, {lw, 0}, {lw, lh}, {0, lh}}, {0xffffffff}, 1)
