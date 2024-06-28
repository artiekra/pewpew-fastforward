require"/dynamic/libs/ppol/.lua"

gh = require"helpers/graphics_helpers"
require"entities/powerups/config"


function make_mesh(color)
  local center = {0,0,0}
  local mesh = gh.new_mesh()

  -- local bottom_center = {center[1], center[2] , center[3]}
  -- local top_center = {center[1], center[2] , center[3] + HEIGHT}
  --
  -- local index_of_first_vertex = #mesh.vertexes
  -- helper.add_poly(mesh, bottom_center, VERTEXES, color, RADIUS, HEIGHT)
  -- helper.add_poly(mesh, top_center, RADIUS, VERTEXES, color, 0)
  --
  -- -- Add the segments linking the 2 regular polygons
  -- for i=1,VERTEXES do
  --   table.insert(mesh.segments, {index_of_first_vertex, index_of_first_vertex + VERTEXES})
  --   index_of_first_vertex = index_of_first_vertex + 1
  -- end

  gh.add_poly(mesh, center, BOX_VERTEXES, color, BOX_RADIUS, BOX_HEIGHT)

  return mesh
end


meshes = {
  make_mesh(0xffffffff)
}
