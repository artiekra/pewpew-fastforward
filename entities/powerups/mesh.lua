gh = require"helpers/graphics_helpers"
ch = require"helpers/color_helpers"

local module = {}

-- Some globals
VERTEXES = 7
HEIGHT = 10
RADIUS = 22


function module.make_mesh(color)
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

  gh.add_poly(mesh, center, VERTEXES, color, RADIUS, HEIGHT)

  return mesh
end


return module
