require"/dynamic/libs/ppol/.lua"

function create_mesh()
  local mesh = def_mesh()
  local s = 10
  local z = 0
  local cf = 1.5  -- used to determine height, "clumping factor"


  local offset_x = -2
  function apply_offset(i, vertex)
    return {vertex[1] + offset_x, vertex[2]}
  end


  raw_vertexes = {{-s, 0, z}, {0, s/cf, z}, {0, -s/cf, z}}
  vertexes = copy_vertexes(raw_vertexes, apply_offset)
  mesh:add_polygon(0xffffffff, table.unpack(vertexes))

  raw_vertexes = {{0, 0, z}, {s, s/cf, z}, {s, -s/cf, z}}
  vertexes = copy_vertexes(raw_vertexes, apply_offset)
  mesh:add_polygon(0xffffffff, table.unpack(vertexes))

  return mesh
end


meshes = {create_mesh()}
